local class = {}

-- \ ------ \ ------------------------------------------------------------ \ --
-- | player | ------------------------------------------------------------ | --
-- \ ------ \ ------------------------------------------------------------ \ --

function class.newPlayer(world)
  local this = {}

  this.world = world
  this.collider = this.world:newCylinderCollider(0, 0, 0, 0.2, 1.5)

  function this:update(dt)
    -- move player here
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
