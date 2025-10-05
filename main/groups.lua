local class = require("class")
local groups = {}

-- \ --- \ --------------------------------------------------------------- \ --
-- | one | --------------------------------------------------------------- | --
-- \ --- \ --------------------------------------------------------------- \ --

function groups.one(world)
  local this = {}
  local super = class.newGroup(world)
  setmetatable(this, { __index = super })

  this.name = "one"
  this.model = lovr.graphics.newModel("assets/one.gltf")
  
  do
    local collider = this.world:newMeshCollider(this.model)
    collider:setTag("group")
    table.insert(this.colliders, collider)
  end

  function this:draw(pass)
    super:draw(pass)
    pass:draw(this.model)
  end

  return this
end

-- \ --- \ --------------------------------------------------------------- \ --
-- | two | --------------------------------------------------------------- | --
-- \ --- \ --------------------------------------------------------------- \ --

function groups.two(world)
  local this = {}
  local super = class.newGroup(world)
  setmetatable(this, { __index = super })

  this.name = "two"
  this.model = lovr.graphics.newModel("assets/two.gltf")
  
  do
    local collider = this.world:newMeshCollider(this.model)
    collider:setTag("group")
    table.insert(this.colliders, collider)
  end

  function this:draw(pass)
    super:draw(pass)
    pass:draw(this.model)
  end

  return this
end

-- \ ----- \ ------------------------------------------------------------- \ --
-- | three | ------------------------------------------------------------- | --
-- \ ----- \ ------------------------------------------------------------- \ --

function groups.three(world)
  local this = {}
  local super = class.newGroup(world)
  setmetatable(this, { __index = super })

  this.name = "three"
  this.model = lovr.graphics.newModel("assets/three.gltf")
  
  do
    local collider = this.world:newMeshCollider(this.model)
    collider:setTag("group")
    table.insert(this.colliders, collider)
  end

  function this:draw(pass)
    super:draw(pass)
    pass:draw(this.model)
  end

  return this
end

-- \ ---- \ -------------------------------------------------------------- \ --
-- | four | -------------------------------------------------------------- | --
-- \ ---- \ -------------------------------------------------------------- \ --

function groups.four(world)
  local this = {}
  local super = class.newGroup(world)
  setmetatable(this, { __index = super })

  this.name = "four"
  this.model = lovr.graphics.newModel("assets/four.gltf")
  
  do
    local collider = this.world:newMeshCollider(this.model)
    collider:setTag("group")
    table.insert(this.colliders, collider)
  end

  function this:draw(pass)
    super:draw(pass)
    pass:draw(this.model)
  end

  return this
end

-- \ ---- \ -------------------------------------------------------------- \ --
-- | five | -------------------------------------------------------------- | --
-- \ ---- \ -------------------------------------------------------------- \ --

function groups.five(world)
  local this = {}
  local super = class.newGroup(world)
  setmetatable(this, { __index = super })

  this.name = "five"
  this.model = lovr.graphics.newModel("assets/five.gltf")
  
  do
    local collider = this.world:newMeshCollider(this.model)
    collider:setTag("group")
    table.insert(this.colliders, collider)
  end

  function this:draw(pass)
    super:draw(pass)
    pass:draw(this.model)
  end

  return this
end

-- \ --- \ --------------------------------------------------------------- \ --
-- | six | --------------------------------------------------------------- | --
-- \ --- \ --------------------------------------------------------------- \ --

function groups.six(world)
  local this = {}
  local super = class.newGroup(world)
  setmetatable(this, { __index = super })

  this.name = "six"
  this.model = lovr.graphics.newModel("assets/six.gltf")
  
  do
    local collider = this.world:newMeshCollider(this.model)
    collider:setTag("group")
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
