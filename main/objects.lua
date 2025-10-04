local class = require("class")
local objects = {}

-- \ ---- \ -------------------------------------------------------------- \ --
-- | Test | -------------------------------------------------------------- | --
-- \ ---- \ -------------------------------------------------------------- \ --

function objects.test()
  local this = {}
  local super = class.newObject()
  setmetatable(this, { __index = super })

  this.groups = { "base" }

  function this:draw(pass)
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

function objects.testB()
  local this = {}
  local super = class.newObject()
  setmetatable(this, { __index = super })

  this.groups = { "two" }

  function draw(pass)
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
