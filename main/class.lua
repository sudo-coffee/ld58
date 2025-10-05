local input = require("input")
local class = {}

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
-- | helpers | ----------------------------------------------------------- | --
-- \ ------- \ ----------------------------------------------------------- \ --

-- \ ----- \ ------------------------------------------------------------- \ --
-- | const | ------------------------------------------------------------- | --
-- \ ----- \ ------------------------------------------------------------- \ --

local MAX_VELOCITY = 1.6
local ACCELERATION = 20
local DECELERATION = 0.6
local TURN_SPEED = 1
local EYE_HEIGHT = 1.3

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
  this.collider:setGravityScale(.4)
  this.collider:setTag("player")

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
  this.collider = this.world:newSphereCollider(0, 0, 0, 0.05)
  this.held = false
  this.active = false
  this.filter = {}
  this.color = { 1, 1, 1, 1 }
  this.range = 2

  -- Collider setup
  this.collider:setTag("item")
  this.collider:setLinearDamping(2)

  function this:renderStart(player) end
  function this:renderGroup(group) end
  function this:renderEnd() end
  function this:drawRender(pass) end

  function this:update(dt) end

  function this:drawItem(pass)
    pass:push()
    pass:setColor(this.color)
    pass:translate(this.collider:getPosition())
    pass:rotate(this.collider:getOrientation())
    pass:cube(0, 0, 0, 0.025)
    pass:pop()
  end

  function this:drawBubble(pass)
    pass:push()
    pass:setColor(this.color[1], this.color[2], this.color[3], 0.1)
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
  local worldSettings = { tags = { "player", "item" } }

  this.world = lovr.physics.newWorld(worldSettings)
  this.groups = {}
  this.items = {}
  this.player = class.newPlayer(this.world)
  this.texture = lovr.graphics.newTexture(width, height, textureOptions)
  this.pass = lovr.graphics.newPass(this.texture)
  this.selectedItem = nil

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
    if this.selectedItem then
      pass:push()
      pass:setColor(.8, .4, .4, .6)
      pass:setDepthTest("none")
      local cameraPosition = vec3(this.player.camera:getPosition())
      local position = vec3(this.selectedItem.collider:getPosition())
      local radius = cameraPosition:distance(position) ^ .2 / 6
      local scale = vec3(radius, radius, radius / 16)
      local orientation = quat(this.player.camera:getOrientation())
      pass:torus(position, scale, orientation)
      pass:pop()
    end
  end

  local function updateItemActivation()
    for _, item in ipairs(this.items) do
      local cameraPosition = vec3(this.player.camera:getPosition())
      local itemPosition = vec3(item.collider:getPosition())
      if cameraPosition:distance(itemPosition) < item.range then
        item.active = true
      else
        item.active = false
      end
    end
  end

  local function updateSelectedItem()
    local selectedItem = nil
    for _, item in ipairs(this.items) do
      if item.active and not item.held then
        selectedItem = item
        break
      end
    end
    this.selectedItem = selectedItem
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
    updateSelectedItem()
    for _, group in ipairs(this.groups) do
      group:update(dt)
    end
    for _, item in ipairs(this.items) do
      item:update(dt)
    end
    this.player:update(dt)
    this.world:update(dt)
  end

  return this
end

-- \ --------------------------------------------------------------------- \ --
-- | --------------------------------------------------------------------- | --
-- \ --------------------------------------------------------------------- \ --

return class
