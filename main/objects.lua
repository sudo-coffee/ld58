local class = require("class")
local groups = require("groups")
local objects = {}

-- \ ---- \ -------------------------------------------------------------- \ --
-- | Test | -------------------------------------------------------------- | --
-- \ ---- \ -------------------------------------------------------------- \ --

function objects.test(world)
  local this = {}
  local super = class.newObject(world)
  setmetatable(this, { __index = super })

  this.group = groups.base
  table.insert(groups.base.objects, this.group)

  function this:draw(pass)
    super:draw(pass)
    pass:push()
    pass:transform(this.transform)
    pass:cube(0, 0, 0, 1, 0, 0, 1, 0, "line")
    pass:pop()
  end

  return this
end

-- \ ------ \ ------------------------------------------------------------ \ --
-- | Test B | ------------------------------------------------------------ | --
-- \ ------ \ ------------------------------------------------------------ \ --

function objects.testB(world)
  local this = {}
  local super = class.newObject(world)
  setmetatable(this, { __index = super })

  this.group = { "two" }

  function draw(pass)
    super:draw(pass)
    pass:push()
    pass:transform(this.transform)
    pass:cube(0, 0, 0, 1, 0, 0, 1, 0, "line")
    pass:pop()
  end

  return this
end

-- \ --------------------------------------------------------------------- \ --
-- | --------------------------------------------------------------------- | --
-- \ --------------------------------------------------------------------- \ --

return objects
