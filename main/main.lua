local input = require("input")
local class = require("class")
local levels = require("levels")
local level = nil

-- \ ------- \ ----------------------------------------------------------- \ --
-- | helpers | ----------------------------------------------------------- | --
-- \ ------- \ ----------------------------------------------------------- \ --

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
