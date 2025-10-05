local class = require("class")
local groups = require("groups")
local items = require("items")
local levels = {}

-- \ ---- \ -------------------------------------------------------------- \ --
-- | main | -------------------------------------------------------------- | --
-- \ ---- \ -------------------------------------------------------------- \ --

function levels.main()
  local this = {}
  local super = class.newLevel()
  setmetatable(this, { __index = super })

  this.player.collider:setPosition(0, 2, 0)

  -- groups
  table.insert(this.groups, groups.room(this.world))

  -- items
  table.insert(this.items, items.base(this.world))

  return this
end

-- \ --------------------------------------------------------------------- \ --
-- | --------------------------------------------------------------------- | --
-- \ --------------------------------------------------------------------- \ --

return levels
