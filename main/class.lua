local class = {}

-- \ ------- \ ----------------------------------------------------------- \ --
-- | helpers | ----------------------------------------------------------- | --
-- \ ------- \ ----------------------------------------------------------- \ --

-- \ ----- \ ------------------------------------------------------------- \ --
-- | group | ------------------------------------------------------------- | --
-- \ ----- \ ------------------------------------------------------------- \ --

function class.newGroup()
  local this = {}
  local enabled = false

  this.objects = {}
  
  function this:enable()
    enabled = true
    for _, object in ipairs(this.objects) do
      object:enable()
    end
  end

  function this:disable()
    enabled = false
    for _, object in ipairs(this.objects) do
      object:disable()
    end
  end

  function this:isEnabled()
    return enabled
  end

  return this
end

-- \ ------ \ ------------------------------------------------------------ \ --
-- | object | ------------------------------------------------------------ | --
-- \ ------ \ ------------------------------------------------------------ \ --

function class.newObject(world, group)
  local this = {}
  local enabled = false

  this.transform = lovr.math.newMat4()
  this.world = world
  this.group = group

  function this:draw(pass) end
  function this:update(dt) end

  function this:enable()
    enabled = true
  end

  function this:disable()
    enabled = false
  end

  function this:isEnabled()
    return enabled
  end

  return this
end

-- \ ---- \ -------------------------------------------------------------- \ --
-- | item | -------------------------------------------------------------- | --
-- \ ---- \ -------------------------------------------------------------- \ --

function class.newItem(world, groups)
  local this = {}
  local enabled = false
  -- local textureOptions = { usage = { "render", "transfer", "sample" } }

  this.transform = lovr.math.newMat4()
  this.camera = lovr.math.newMat4()
  this.world = world
  this.groups = groups
  this.pass = lovr.graphics.newPass()
  this.range = 0.001
  this.shader = nil

  function this:update(dt) end
  function this:groupStart(group, player) end
  function this:groupEnd(group, player) end
  function this:apply(pass) end

  function this:enable()
    enabled = true
  end

  function this:disable()
    enabled = false
  end

  function this:isEnabled()
    return enabled
  end

  return this
end

-- \ ----- \ ------------------------------------------------------------- \ --
-- | level | ------------------------------------------------------------- | --
-- \ ----- \ ------------------------------------------------------------- \ --

function class.newLevel()
  local this = {}

  this.objects = {}
  this.items = {}
  this.groups = {}
  this.world = lovr.physics.newWorld()
  this.player = lovr.physics.newCylinderCollider(0, 0, 0, 0.5, 2)

  local function drawItem(item)
    -- draw small objects with transparent spheres here
  end

  function this:draw(pass)
    for _, item in ipairs(this.items) do
      if item.enabled then
        local camera = 
        item:drawStart()
        for _, group in ipairs(item.groups) do
          item:groupStart(group)
          for _, object in ipairs(this.objects) do
            if group == object.group then
              object:draw(item.pass)
            end
          end
          item:groupEnd(group)
        end
        item:apply(pass)
      end
    end
  end

  function this:update(dt)

    -- Update player
    -- movement controls here!

    -- Update items
    for _, item in ipairs(this.items) do
      local playerPosition = lovr.math.vec3(this.player:getPosition())
      local itemPosition = lovr.math.vec3(item.transform:getPosition())
      if playerPosition:distance(itemPosition) <= item.range then
        item:enable()
      else
        item:disable()
      end
      item:update(dt)
    end

    -- Update groups
    for _, group in ipairs(this.groups) do
      local enable = false
      for _, item in ipairs(this.items) do
        if item:isEnabled() then
          for _, itemGroup in item.groups do
            if group == 
        end
      end
      if item:isEnabled() then
        for _, group in ipairs(item.groups) do
          
          updateGroupEnabled(group)
        end
      end
      local playerPosition = lovr.math.vec3(this.player:getPosition())
      local itemPosition = lovr.math.vec3(item.transform:getPosition())
      if playerPosition:distance(itemPosition) < item.range then
        item:enable()
        for _, object in ipairs(this.objects) do
          local enabled = false
          for _, group in ipairs(item.groups) do
            if object.group == group then
              enabled = true
              group:enable()
              break
            end
          end
          if not enabled then
            group:disable()
          end
        end
      else
        item.enabled = false
        item:disable()
      end
    end
    for _, object in ipairs(this.objects) do
      object:update(dt)
      for _, item in ipairs(this.items) do
        for _, group in ipairs(item.groups) do
          if object.group == 
        end
      end
    end
    updatePlayer(dt)
    this.world:update(dt)
  end

  return this
end

-- \ --------------------------------------------------------------------- \ --
-- | --------------------------------------------------------------------- | --
-- \ --------------------------------------------------------------------- \ --

return class
