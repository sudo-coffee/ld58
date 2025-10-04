local class = require("class")
local groups = require("groups")
local items = {}

-- \ ---- \ -------------------------------------------------------------- \ --
-- | Base | -------------------------------------------------------------- | --
-- \ ---- \ -------------------------------------------------------------- \ --

function items.base(world)
  local this = {}
  local super = class.newItem(world)
  setmetatable(this, { __index = super })

  this.groups = { groups.base }

  return this
end

-- \ ---- \ -------------------------------------------------------------- \ --
-- | Test | -------------------------------------------------------------- | --
-- \ ---- \ -------------------------------------------------------------- \ --

function items.two(world)
  local this = {}
  local super = class.newItem(world)
  setmetatable(this, { __index = super })

  this.group = { groups.base, groups.two }

  return this
end

-- \ --------------------------------------------------------------------- \ --
-- | --------------------------------------------------------------------- | --
-- \ --------------------------------------------------------------------- \ --

return items
