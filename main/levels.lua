local objects = require("objects")
local items = require("items")
local class = require("class")
local levels = {}

-- \ ---- \ -------------------------------------------------------------- \ --
-- | main | -------------------------------------------------------------- | --
-- \ ---- \ -------------------------------------------------------------- \ --

function levels.main()
  local this = {}
  local super = class.newLevel()
  setmetatable(this, { __index = super })

  do
    local object = objects.test(this.world)
    object.transform:translate(0, 0, -5)
    table.insert(this.objects, object)
  end

  do
    local item = items.base()
    table.insert(this.items, item)
  end

  do
    local item = items.test()
    table.insert(this.items, item)
  end

  function this:update(dt)
    super:update(dt)
  end

  return this
end

-- \ --------------------------------------------------------------------- \ --
-- | --------------------------------------------------------------------- | --
-- \ --------------------------------------------------------------------- \ --

return levels
