local input = require("input")
local class = {}

local theend = false

-- global
local source = lovr.audio.newSource("assets/wind.mp3")
source:play()
source:setVolume(0)
source:setLooping(true)

-- \ ------- \ ----------------------------------------------------------- \ --
-- | private | ----------------------------------------------------------- | --
-- \ ------- \ ----------------------------------------------------------- \ --

-- In radians
local function playerTurn(transform, vecX, vecY)
  local position = vec3(transform:getPosition())
  local orientation = quat(transform:getOrientation())
  local radX, radY, radZ = orientation:getEuler()
  local degX, degY, degZ = math.deg(radX), math.deg(radY), math.deg(radZ)
  degX = degX - math.deg(vecX)
  degY = degY - math.deg(vecY)
  degZ = 0
  if degX >   89 then degX =         89 end
  if degX <  -89 then degX =        -89 end
  if degY >  180 then degY = degY - 360 end
  if degY < -180 then degY = degY + 360 end
  radX, radY, radZ = math.rad(degX), math.rad(degY), math.deg(degZ)
  orientation:setEuler(radX, radY, radZ)
  transform:set(position, orientation)
end

-- In meters
local function getPlayerDelta(transform, vecX, vecZ)
  local position = vec3(transform:getPosition())
  local back = vec3(transform[9], 0, transform[11]):normalize()
  local right = vec3(transform[1], 0, transform[3]):normalize()
  local delta = right * vecX + back * vecZ
  return delta.x, delta.y, delta.z
end

local function printPlayerInfo(player)
  local colX, colY, colZ = player.collider:getPosition()
  local camX, camY, camZ = player.camera:getPosition()
  local orientation = quat(player.camera:getOrientation())
  local radX, radY, radZ = orientation:getEuler()
  local degX, degY, degZ = math.deg(radX), math.deg(radY), math.deg(radZ)
  print()
  print(string.format("collider : % 5.2f % 5.2f % 5.2f", colX, colY, colZ))
  print(string.format("camera   : % 5.2f % 5.2f % 5.2f", camX, camY, camZ))
  print(string.format("rotation : % 5.2f % 5.2f % 5.2f", degX, degY, degZ))
end

-- \ ------- \ ----------------------------------------------------------- \ --
-- | private | ----------------------------------------------------------- | --
-- \ ------- \ ----------------------------------------------------------- \ --

-- \ ------- \ ----------------------------------------------------------- \ --
-- | helpers | ----------------------------------------------------------- | --
-- \ ------- \ ----------------------------------------------------------- \ --

-- \ ----- \ ------------------------------------------------------------- \ --
-- | const | ------------------------------------------------------------- | --
-- \ ----- \ ------------------------------------------------------------- \ --

local MAX_VELOCITY = 4
local ACCELERATION = 20
local DECELERATION = 0.6
local TURN_SPEED = 1
local EYE_HEIGHT = 1.3
local LINEAR_DAMPING = 1

-- \ ------ \ ------------------------------------------------------------ \ --
-- | player | ------------------------------------------------------------ | --
-- \ ------ \ ------------------------------------------------------------ \ --

function class.newPlayer(world)
  local this = {}

  this.world = world
  this.collider = this.world:newCylinderCollider(0, 0, 0, 0.2, 1.5)
  this.camera = lovr.math.newMat4()
  this.velocity = lovr.math.newVec3()

  -- Collider setup
  -- TODO: rotate cylinder so it's always upright
  this.collider:setMass(99999999)
  this.collider:setTag("player")
  this.collider:setLinearDamping(LINEAR_DAMPING)

  function this:update(dt)
    -- Input vectors
    local moveX, moveZ = input.getMoveVector()
    local turnY, turnX = input.getTurnVector()

    -- Update camera rotation
    playerTurn(this.camera, turnX * TURN_SPEED, turnY * TURN_SPEED)

    -- Update velocity
    local deltaX, _, deltaZ = getPlayerDelta(this.camera, moveX, moveZ)
    local deltaH = vec2(deltaX, deltaZ)
    local oldX, oldY, oldZ = this.collider:getLinearVelocity()
    local newH = vec2(oldX, oldZ)
    if deltaH:length() == 0 then newH:div(DECELERATION + 1) end
    newH:add(deltaH * dt * ACCELERATION)
    newH:div(math.max(1, newH:length() / MAX_VELOCITY))

    -- Update Collider
    -- TODO: rotate cylinder so it's always upright
    this.collider:setOrientation()
    this.collider:setLinearVelocity(newH.x, oldY, newH.y)

    -- Update camera position
    local posX, posY, posZ = this.collider:getPosition()
    local position = vec3(posX, posY + EYE_HEIGHT, posZ)
    local orientation = quat(this.camera:getOrientation())
    this.camera:set(position, orientation)
  
    -- Wrap to top of world, adjust gravity
    if posY < -4096 and not theend then
      this.collider:setPosition(posX, posY + 4128, posZ)
      this.collider:setLinearVelocity(0, 0, 0)
      this.collider:setGravityScale(0.4)
    elseif posY < 0 then
      this.collider:setGravityScale(math.abs(posY) + 1)
    end
    
    -- Set sound effect volume
    velX, velY, velZ = this.collider:getLinearVelocity()
    source:setVolume(math.max(math.min(-velY / 128, 0.8), 0))
  end

  return this
end

-- \ ----- \ ------------------------------------------------------------- \ --
-- | group | ------------------------------------------------------------- | --
-- \ ----- \ ------------------------------------------------------------- \ --

function class.newGroup(world)
  local this = {}

  this.world = world
  this.colliders = {}
  this.name = "nil"

  function this:draw(pass) end
  function this:update(dt) end

  return this
end

-- \ ---- \ -------------------------------------------------------------- \ --
-- | item | -------------------------------------------------------------- | --
-- \ ---- \ -------------------------------------------------------------- \ --

function class.newItem(world)
  local this = {}

  this.world = world
  this.collider = this.world:newSphereCollider(0, 0, 0, 0.2)
  this.held = false
  this.active = false
  this.filter = {}
  this.color = { 1, 1, 1, 1 }
  this.range = 2
  this.theend = false

  -- Collider setup
  this.collider:setTag("item")
  this.collider:setLinearDamping(LINEAR_DAMPING)
  this.collider:setMass(0.4)

  function this:renderStart(player) end
  function this:renderGroup(group) end
  function this:renderEnd() end
  function this:drawRender(pass) end

  function this:update(dt)
    local posX, posY, posZ = this.collider:getPosition()
    if posY < -4096 and not theend then
      this.collider:setPosition(posX, posY + 4128, posZ)
      this.collider:setLinearVelocity(0, 0, 0)
      this.collider:setGravityScale(0.4)
    elseif posY < 0 then
      this.collider:setGravityScale(math.abs(posY) + 1)
    end
  end

  function this:drawItem(pass)
    pass:push()
    pass:setColor(this.color)
    pass:translate(this.collider:getPosition())
    pass:rotate(this.collider:getOrientation())
    pass:cube(0, 0, 0, 0.1)
    pass:pop()
  end

  function this:drawBubble(pass)
    pass:push()
    pass:setColor(this.color[1], this.color[2], this.color[3], 0.4)
    pass:translate(this.collider:getPosition())
    pass:rotate(this.collider:getOrientation())
    pass:sphere(0, 0, 0, this.range)
    pass:pop()
  end

  return this
end

-- \ ----- \ ------------------------------------------------------------- \ --
-- | level | ------------------------------------------------------------- | --
-- \ ----- \ ------------------------------------------------------------- \ --

function class.newLevel()
  local this = {}
  local width, height = lovr.system.getWindowDimensions()
  local worldSettings = {
    tags = { "player", "item", "group" },
    velocitySteps = 32,
    positionSteps = 16
  }

  this.world = lovr.physics.newWorld(worldSettings)
  this.groups = {}
  this.items = {}
  this.player = class.newPlayer(this.world)
  this.texture = lovr.graphics.newTexture(width, height, textureOptions)
  this.pass = lovr.graphics.newPass(this.texture)
  this.theend = false
  
  -- World setup
  this.world:disableCollisionBetween("player", "item")

  -- not tested, should occlude items and bubbles
  local function drawGroups(pass)
    pass:push()
    pass:setColorWrite(false) -- Just depth tests
    local groupSet = {}
    for _, item in ipairs(this.items) do
      if item.active then
        for _, group in ipairs(this.groups) do
          for _, name in ipairs(item.filter) do
            if group.name == name then
              groupSet[group] = true
            end
          end
        end
      end
    end
    for group, _ in pairs(groupSet) do
      group:draw(pass)
    end
    pass:setColorWrite(true)
    pass:pop()
  end

  local function renderGroups()
    for _, item in ipairs(this.items) do
      if item.active then
        item:renderStart(this.player)
        for _, group in ipairs(this.groups) do
          for _, name in ipairs(item.filter) do
            if group.name == name then
              item:renderGroup(group)
            end
          end
        end
        item:renderEnd()
      end
    end
  end

  local function drawRenders(pass)
    for _, item in ipairs(this.items) do
      if item.active then
        item:drawRender(pass)
      end
    end
  end

  local function drawItems(pass)
    for _, item in ipairs(this.items) do
      if not item.held then
        item:drawItem(pass)
      end
    end
  end

  local function drawBubbles(pass)
    -- Transparency sorting
    local sorted = {}
    for _, item in ipairs(this.items) do
      if not item.held and not item.active then
        table.insert(sorted, item)
      end
    end
    local playerPos = vec3(this.player.collider:getPosition())
    table.sort(sorted, function(a, b)
      local aDist = playerPos:distance(a.collider:getPosition())
      local bDist = playerPos:distance(b.collider:getPosition())
      return aDist > bDist
    end)
    for _, item in ipairs(sorted) do
      item:drawBubble(pass)
    end
  end

  local function drawSelector(pass)
    pass:push()
    pass:setColor(.8, .4, .4, .6)
    pass:setDepthTest("none")
    for _, item in ipairs(this.items) do
      if item.active and not item.held then
        local cameraPosition = vec3(this.player.camera:getPosition())
        local position = vec3(item.collider:getPosition())
        local radius = cameraPosition:distance(position) ^ .2 / 4
        local scale = vec3(radius, radius, radius / 16)
        local orientation = quat(this.player.camera:getOrientation())
        pass:torus(position, scale, orientation)
      end
    end
    pass:pop()
  end

  local function updateItemActivation()
    for _, item in ipairs(this.items) do
      if not item.held then
        local cameraPosition = vec3(this.player.camera:getPosition())
        local itemPosition = vec3(item.collider:getPosition())
        if this.theend then
          item.active = false
        elseif cameraPosition:distance(itemPosition) < item.range then
          item.active = true
        else
          item.active = false
        end
      end
    end
  end

  function this:draw(pass)
    this.pass:reset()
    this.pass:setViewPose(1, this.player.camera:getPose())
    drawGroups(this.pass)
    renderGroups()
    drawItems(this.pass)
    drawBubbles(this.pass)
    drawSelector(this.pass)
    lovr.graphics.submit(this.pass)
    drawRenders(pass)
    pass:fill(this.texture)
  end

  function this:update(dt)
    updateItemActivation()
    for _, group in ipairs(this.groups) do
      group:update(dt)
    end
    for _, item in ipairs(this.items) do
      item:update(dt)
    end
    this.player:update(dt)
    this.world:update(dt)
  end

  function this:action()
    local cameraPosition = vec3(this.player.camera:getPosition())
    local closestItem = nil
    local closestDistance = nil
    for _, item in ipairs(this.items) do
      if item.active and not item.held then
        local itemPosition = vec3(item.collider:getPosition())
        local distance = cameraPosition:distance(itemPosition)
        if not closestDistance or distance < closestDistance then
          closestDistance = distance
          closestItem = item
        end
      end
    end
    if closestItem then
      closestItem.held = true
      closestItem.active = true
      closestItem.collider:setKinematic(true)
      if closestItem.theend then
        this.theend = true
        theend = true
        this.world:disableCollisionBetween("player", "group")
        this.world:disableCollisionBetween("item", "group")
        lovr.graphics.setBackgroundColor(.1, .1, .2)
        for _, item in ipairs(this.items) do
          if not item.theend and item.held then
            item.active = false
          end
        end
      end
    else
      local randomItem = {}
      for _, item in ipairs(this.items) do
        if item.held then
          table.insert(randomItem, item)
        end
      end
      if #randomItem > 0 then
        local index = math.floor(math.random() * #randomItem) + 1
        local item = randomItem[index]
        local forwardX = -this.player.camera[9]
        local forwardY = -this.player.camera[10]
        local forwardZ = -this.player.camera[11]
        local forward = vec3(forwardX, forwardY, forwardZ)
        local impulse = vec3(forwardX, forwardY + 0.4, forwardZ) * 4
        item.held = false
        item.collider:setKinematic(false)
        item.collider:setPosition(cameraPosition + forward / 4)
        item.collider:applyLinearImpulse(impulse)
        if item.theend then
          this.theend = false
          theend = false
          this.world:enableCollisionBetween("player", "group")
          this.world:enableCollisionBetween("item", "group")
          lovr.graphics.setBackgroundColor(.5, .5, .6)
          for _, item in ipairs(this.items) do
            if not item.theend and item.held then
              item.active = true
            end
          end
        end
      end
    end
  end

  function this:destroy()
    this.world:destroy()
  end

  return this
end

-- \ --------------------------------------------------------------------- \ --
-- | --------------------------------------------------------------------- | --
-- \ --------------------------------------------------------------------- \ --

return class
