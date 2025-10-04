local objects = require("objects")
local items = require("items")
local class = require("class")
local levels = {}

-- \ ---- \ -------------------------------------------------------------- \ --
-- | Main | -------------------------------------------------------------- | --
-- \ ---- \ -------------------------------------------------------------- \ --

function levels.main()
  local this = {}
  local super = class.newLevel()
  setmetatable(this, { __index = super })

  do
    local object = objects.test()
    object.transform:translate(0, 5, 0)
    table.insert(this.objects, object)
  end

  do
    local item = items.player()
    table.insert(this.items, item)
  end

  do
    local item = items.test()
    table.insert(this.items, item)
  end

  return this
end

-- \ --------------------------------------------------------------------- \ --
-- | --------------------------------------------------------------------- | --
-- \ --------------------------------------------------------------------- \ --

return levels
