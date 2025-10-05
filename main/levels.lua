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
  table.insert(this.groups, groups.one(this.world))
  table.insert(this.groups, groups.two(this.world))
  table.insert(this.groups, groups.three(this.world))
  table.insert(this.groups, groups.four(this.world))
  table.insert(this.groups, groups.five(this.world))
  table.insert(this.groups, groups.six(this.world))

  -- items
  table.insert(this.items, items.one(this.world))
  table.insert(this.items, items.two(this.world))
  table.insert(this.items, items.three(this.world))
  table.insert(this.items, items.four(this.world))
  table.insert(this.items, items.five(this.world))
  table.insert(this.items, items.six(this.world))

  return this
end

-- \ --------------------------------------------------------------------- \ --
-- | --------------------------------------------------------------------- | --
-- \ --------------------------------------------------------------------- \ --

return levels
