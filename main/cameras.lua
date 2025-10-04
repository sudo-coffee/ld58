local class = require("class")
local cameras = {}

-- \ ------ \ ------------------------------------------------------------ \ --
-- | Player | ------------------------------------------------------------ | --
-- \ ------ \ ------------------------------------------------------------ \ --

function cameras.player()
  local this = {}
  local super = class.newCamera()
  setmetatable(this, { __index = super })

  this.groups = { "base" }
  this.enabled = true -- player always starts enabled

  return this
end

-- \ ---- \ -------------------------------------------------------------- \ --
-- | Test | -------------------------------------------------------------- | --
-- \ ---- \ -------------------------------------------------------------- \ --

function cameras.test()
  local this = {}
  local super = class.newCamera()
  setmetatable(this, { __index = super })

  this.groups = { "two" }

  return this
end

-- \ --------------------------------------------------------------------- \ --
-- | --------------------------------------------------------------------- | --
-- \ --------------------------------------------------------------------- \ --

return cameras
