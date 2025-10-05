local input = require("input")
local class = require("class")
local levels = require("levels")
local level = nil
local state = "title"
local option = 1

-- \ ------- \ ----------------------------------------------------------- \ --
-- | helpers | ----------------------------------------------------------- | --
-- \ ------- \ ----------------------------------------------------------- \ --

local function drawTitle(pass)
  pass:plane(0, 0, -5, 1,     1.618, 0, 0, 0, 0, "line")
  pass:plane(0, 0, -5, 1.618, 1,     0, 0, 0, 0, "line")
  pass:plane(0, 0, -5, 1.618, 1.618, 0, 0, 0, 0, "line")
  pass:setColor(.8, .4, .4, .6)
  pass:torus(0, 0, -5, .35, .02)
end

local function drawExit(pass)
  pass:plane(-1.3, 0, -5, 1,     1.618, 0, 0, 0, 0, "line")
  pass:plane(-1.3, 0, -5, 1.618, 1,     0, 0, 0, 0, "line")
  pass:plane(-1.3, 0, -5, 1.618, 1.618, 0, 0, 0, 0, "line")
  pass:plane( 1.3, 0, -5, 1,     1.618, 0, 0, 0, 0, "line")
  pass:plane( 1.3, 0, -5, 1.618, 1,     0, 0, 0, 0, "line")
  pass:plane( 1.3, 0, -5, 1.618, 1.618, 0, 0, 0, 0, "line")
  pass:setColor(.5, .5, .5)
  pass:plane(-1.3, 0, -5, 0.35,   0.35,   0, 0, 0, 0, "fill")
  pass:polygon(1.15, 0.2, -5, 1.15, -0.2, -5, 1.45, 0, -5)
  pass:setColor(.8, .4, .4, .6)
  pass:plane(-3.9 + option * 2.6, 0, -5, 1.818, 1.818, 0, 0, 0, 0, "line")
  pass:plane(-3.9 + option * 2.6, 0, -5, 1.828, 1.828, 0, 0, 0, 0, "line")
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
  if state == "main" then
    level:update(dt)
  end
end

function lovr.draw(pass)
  if state == "main" then
    level:draw(pass)
  elseif state == "title" then
    drawTitle(pass)
  elseif state == "exit" then
    drawExit(pass)
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
