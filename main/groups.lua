local class = require("class")
local groups = {}

-- \ ---- \ -------------------------------------------------------------- \ --
-- | room | -------------------------------------------------------------- | --
-- \ ---- \ -------------------------------------------------------------- \ --

function groups.room(world)
  local this = {}
  local super = class.newGroup(world)
  setmetatable(this, { __index = super })

  this.name = "room"

  do
    local collider = this.world:newBoxCollider(0, -0.5, 0, 10, 1, 10)
    collider:setKinematic(true)
    table.insert(this.colliders, collider)
  end

  function this:draw(pass)
    super:draw(pass)
    pass:box(0, -0.5, 0, 10, 1, 10)
  end

  return this
end

-- \ --------------------------------------------------------------------- \ --
-- | --------------------------------------------------------------------- | --
-- \ --------------------------------------------------------------------- \ --

return groups
