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

function lovr.keypressed(key, scancode, repeated)
  input.keypressed(key, scancode, repeated)
end

function lovr.mousemoved(x, y, dx, dy)
  input.mousemoved(x, y, dx, dy)
end

function input.exit()
  -- TODO: add confirmation here
  lovr.event.quit()
end

function input.action()
  level:action()
end

-- \ --------------------------------------------------------------------- \ --
-- | --------------------------------------------------------------------- | --
-- \ --------------------------------------------------------------------- \ --
