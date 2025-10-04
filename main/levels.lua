local objects = require("objects")
local cameras = require("cameras")
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
    local camera = cameras.player()
    table.insert(this.cameras, camera)
  end

  do
    local camera = cameras.test()
    table.insert(this.cameras, camera)
  end

  return this
end

-- \ --------------------------------------------------------------------- \ --
-- | --------------------------------------------------------------------- | --
-- \ --------------------------------------------------------------------- \ --

return levels
