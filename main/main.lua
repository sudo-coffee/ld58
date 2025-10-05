local input = require("input")
local class = require("class")
local levels = require("levels")
local level = nil
local state = "title"
local option = 1

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
  if state == "main" then
    level:update(dt)
  end
end

function lovr.draw(pass)
  if state == "main" then
    level:draw(pass)
  end
end

function lovr.keypressed(key, scancode, repeated)
  input.keypressed(key, scancode, repeated)
end

function lovr.mousemoved(x, y, dx, dy)
  input.mousemoved(x, y, dx, dy)
end

function lovr.mousepressed(x, y, button)
  input.mousepressed(x, y, button)
end

function input.exit()
  if state == "main" then
    state = "exit"
    option = 1
  elseif state == "exit" then
    state = "main"
  elseif state == "title" then
    state = "main"
  end
end

function input.action()
  if state == "main" then
    level:action()
  elseif state == "exit" and option == 1 then
    lovr.event.quit()
  elseif state == "exit" and option == 2 then
    state = "main"
  elseif state == "title" then
    state = "main"
  end
end

function input.menuLeft()
  if option == 2 then option = 1 end
end

function input.menuRight()
  if option == 1 then option = 2 end
end

-- \ --------------------------------------------------------------------- \ --
-- | --------------------------------------------------------------------- | --
-- \ --------------------------------------------------------------------- \ --
