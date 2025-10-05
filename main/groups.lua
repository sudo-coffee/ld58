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
  this.model = lovr.graphics.newModel("assets/room.gltf")
  
  do
    local collider = this.world:newMeshCollider(this.model)
    table.insert(this.colliders, collider)
  end

  function this:draw(pass)
    super:draw(pass)
    pass:draw(this.model)
  end

  return this
end

-- \ --------------------------------------------------------------------- \ --
-- | --------------------------------------------------------------------- | --
-- \ --------------------------------------------------------------------- \ --

return groups
