local class = require("class")
local items = {}

-- \ ---- \ -------------------------------------------------------------- \ --
-- | base | -------------------------------------------------------------- | --
-- \ ---- \ -------------------------------------------------------------- \ --

function items.base(world)
  local this = {}
  local super = class.newItem(world)
  setmetatable(this, { __index = super })
  local textureOptions = { usage = { "render", "sample" } }
  local width, height = lovr.system.getWindowDimensions()

  this.filter = { "room" }
  this.texture = lovr.graphics.newTexture(width, height, textureOptions)
  this.pass = lovr.graphics.newPass(this.texture)
  this.collider:setPosition(2, 2, -6)

  function this:renderStart(player)
    super:renderStart(player)
    this.pass:reset()
    this.pass:setViewPose(1, player.camera:getPose())
  end

  function this:renderGroup(group)
    super:renderGroup(group)
    group:draw(this.pass)
  end

  function this:drawRender(pass)
    super:drawRender(pass)
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
