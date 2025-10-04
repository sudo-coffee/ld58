local input = require("input")
local class = {}

-- \ ------- \ ----------------------------------------------------------- \ --
-- | helpers | ----------------------------------------------------------- | --
-- \ ------- \ ----------------------------------------------------------- \ --

-- In radians
local function playerTurn(transform, vecX, vecY)
  local position = lovr.math.vec3(transform:getPosition())
  local orientation = lovr.math.quat(transform:getOrientation())
  orientation = orientation * lovr.math.quat(vecX, 1, 0, 0)
  orientation = lovr.math.quat(vecY, 0, 1, 0) * orientation
  transform:set(position, orientation)
end

-- In meters
local function getPlayerDelta(transform, vecX, vecZ)
  local position = lovr.math.vec3(transform:getPosition())
  local orientation = lovr.math.quat(transform:getOrientation())
  local back = lovr.math.vec3(transform[9], 0, transform[11]):normalize()
  local right = lovr.math.vec3(transform[1], 0, transform[3]):normalize()
  local delta = right * vecX + back * vecZ
  return delta.x, delta.y, delta.z
end

-- \ ----- \ ------------------------------------------------------------- \ --
-- | const | ------------------------------------------------------------- | --
-- \ ----- \ ------------------------------------------------------------- \ --

local MAX_VELOCITY = 1
local ACCELERATION = 40
local DECELERATION = 10
local TURN_SPEED = 2

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
  this.collider:setMass(99999999)
  this.collider:setGravityScale(.4)

  function this:update(dt)
    -- Input vectors
    local moveX, _, moveZ = input.getMoveVector()
    local turnX, turnY, _ = input.getTurnVector()

    -- Update camera rotation
    playerTurn(this.camera, turnX, turnY)

    -- Update velocity
    local deltaX, _, deltaZ = getPlayerDelta(this.camera, moveX, moveZ)
    local deltaH = lovr.math.vec2(deltaX, deltaZ)
    local _, oldY, _ = this.collider:getLinearVelocity()
    local newH = lovr.math.vec2(oldX, oldZ)
    if deltaH:length() == 0 then newH:div(DECELERATION) end
    newH:add(deltaH * dt * ACCELERATION)
    newH:div(math.max(1, newH:length() / MAX_VELOCITY))

    -- Update Collider
    this.collider:setLinearVelocity(newH.x, oldY, newH.y)
    this.collider:setOrientation()
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

  function this:update(dt) end
  function this:renderGroup(group) end
  function this:drawRender(pass) end
  function this:drawItem(pass) end
  function this:drawBubble(pass) end

  return this
end

-- \ ----- \ ------------------------------------------------------------- \ --
-- | level | ------------------------------------------------------------- | --
-- \ ----- \ ------------------------------------------------------------- \ --

function class.newLevel()
  local this = {}

  this.world = lovr.physics.newWorld()
  this.groups = {}
  this.items = {}
  this.player = class.newPlayer(this.world)

  local function renderGroups()
    for _, item in ipairs(this.items) do
      if item.active then
        for _, group in ipairs(this.groups) do
          for _, name in ipairs(item.filter) do
            if item.name == name then
              item:renderGroup(group)
            end
          end
        end
      end
    end
  end

  local function drawRenders(pass)
    for _, item in ipairs(this.items) do
      if item.active then
        item.drawRender(pass)
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
    local playerPos = lovr.math.vec3(this.player.collider:getPosition())
    table.sort(sorted, function(a, b)
      local aDist = playerPos:distance(a.collider:getPosition())
      local bDist = playerPos:distance(b.collider:getPosition())
      return aDist > bDist
    end)
    for _, item in ipairs(sorted) do
      item:drawBubble(pass)
    end
  end

  function this:draw(pass)
    renderGroups()
    drawRenders(pass)
    drawItems(pass)
    drawBubbles(pass)
  end

  function this:update(dt)
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
