local class = require("class")
local items = {}

-- \ ---- \ -------------------------------------------------------------- \ --
-- | base | -------------------------------------------------------------- | --
-- \ ---- \ -------------------------------------------------------------- \ --

function items.base(world)
  local this = class.newItem(world)
  local super = class.newItem(world)
  setmetatable(this, { __index = super })
  local textureOptions = { usage = { "render", "sample" } }

  this.active = true -- for testing
  this.filter = { "room" }
  this.texture = lovr.graphics.newTexture(800, 800, textureOptions)
  this.pass = lovr.graphics.newPass(this.texture)

  function this:renderStart(player)
    this.pass:reset()
    this.pass:setViewPose(1, player.camera:getPose())
  end

  function this:renderGroup(group)
    group:draw(this.pass)
  end

  function this:drawRender(pass)
    -- pass:box(0, -0.5, 0, 10, 1, 10, 0, 0, 1, 0, "line")
    -- pass:cube(0, 0, -5, 2, 0, 0, 1, 0, "line") -- test
    pass:push()
    pass:origin()
    lovr.graphics.submit(this.pass)
    pass:fill(this.texture)
    pass:pop()
  end

  return this
end

-- \ --------------------------------------------------------------------- \ --
-- | --------------------------------------------------------------------- | --
-- \ --------------------------------------------------------------------- \ --

return items
