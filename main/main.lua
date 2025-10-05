local input = require("input")
local class = require("class")
local levels = require("levels")
local level = nil
local delay = 100
local started = false

-- \ ------- \ ----------------------------------------------------------- \ --
-- | helpers | ----------------------------------------------------------- | --
-- \ ------- \ ----------------------------------------------------------- \ --

local function start()
end

-- \ --------- \ --------------------------------------------------------- \ --
-- | callbacks | --------------------------------------------------------- | --
-- \ --------- \ --------------------------------------------------------- \ --

function lovr.load()
  input.load()
  level = levels.main()
end

function lovr.update(dt)
  input.update(dt)
  level:update(dt)
  -- print(lovr.system.getWindowDimensions())
end

function lovr.draw(pass)
  level:draw(pass)
end

function lovr.keypressed(key)
  if key == "escape" then
    lovr.event.quit()
  end
end

function lovr.mousemoved(x, y, dx, dy)
  input.mousemoved(x, y, dx, dy)
end

-- \ --------------------------------------------------------------------- \ --
-- | --------------------------------------------------------------------- | --
-- \ --------------------------------------------------------------------- \ --
