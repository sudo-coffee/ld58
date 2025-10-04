local class = {}

-- \ ------- \ ----------------------------------------------------------- \ --
-- | Helpers | ----------------------------------------------------------- | --
-- \ ------- \ ----------------------------------------------------------- \ --

local function doGroupsMatch(item, object)
  local match = false
  for _, itemGroup in ipairs(item.groups) do
    for _, objectGroup in ipairs(object.groups) do
      if objectGroup == itemGroup then
        match = true
        break
      end
    end
    if match then
      break
    end
  end
  return match
end

-- \ ------ \ ------------------------------------------------------------ \ --
-- | object | ------------------------------------------------------------ | --
-- \ ------ \ ------------------------------------------------------------ \ --

function class.newObject()
  local this = {}

  this.transform = lovr.math.newMat4()
  this.groups = {} -- strings

  function this:draw(pass) end
  function this:update(dt) end

  return this
end

-- \ ---- \ -------------------------------------------------------------- \ --
-- | Item | -------------------------------------------------------------- | --
-- \ ---- \ -------------------------------------------------------------- \ --

function class.newItem()
  local this = {}
  local textureOptions = { usage = { "render", "transfer" } }

  this.transform = lovr.math.newMat4()
  this.camera = lovr.math.newMat4()
  this.groups = {} -- strings
  this.texture = lovr.graphics.newTexture(800, 800, textureOptions)
  this.enabled = false
  this.range = 0
  this.shader = nil

  function this:getPass()
    this.texture:clear()
    local pass = lovr.graphics.newPass(this.texture)
    return pass
  end

  function this:update(dt) end

  return this
end

-- \ ----- \ ------------------------------------------------------------- \ --
-- | Level | ------------------------------------------------------------- | --
-- \ ----- \ ------------------------------------------------------------- \ --

function class.newLevel()
  local this = {}

  this.objects = {}
  this.items = {}

  function this:draw(pass)
    for _, item in ipairs(this.items) do
      if item.enabled then
        local itemPass = item:getPass()
        for _, object in ipairs(this.objects) do
          if doGroupsMatch(item, object) then
            object:draw(itemPass)
          end
        end
      end
    end
    -- combine textures here
  end

  function this:update(dt)
    for _, object in ipairs(this.objects) do
      object:update(dt)
    end
    for _, item in ipairs(this.items) do
      item:update(dt)
    end
  end

  return this
end

-- \ --------------------------------------------------------------------- \ --
-- | --------------------------------------------------------------------- | --
-- \ --------------------------------------------------------------------- \ --

return class
