local class = require("class")
local items = {}

-- \ ---- \ -------------------------------------------------------------- \ --
-- | base | -------------------------------------------------------------- | --
-- \ ---- \ -------------------------------------------------------------- \ --

function items.base(world)
  local this = class.newItem(world)
  local super = class.newItem(world)
  setmetatable(this, { __index = super })
  local textureOptions = { usage = { "render", "transfer", "sample" } }

  this.active = true -- for testing
  this.filter = { "room" }
  this.texture = lovr.graphics.newTexture(800, 800, textureOptions)
  this.pass = lovr.graphics.newPass(this.texture)

  function this:renderStart()
    this.texture:clear()
  end

  function this:renderGroup(group)
    group:draw(pass)
  end

  function this:drawRender(pass)
    pass:cube(0, 0, -5, 2, 0, 0, 1, 0, "line")
  end

  return this
end

-- \ --------------------------------------------------------------------- \ --
-- | --------------------------------------------------------------------- | --
-- \ --------------------------------------------------------------------- \ --

return items
