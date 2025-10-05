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

local function drawMenu(pass)
  pass:plane(-2.6, 0, -5, 1,     1.618, 0, 0, 0, 0, "line")
  pass:plane(-2.6, 0, -5, 1.618, 1,     0, 0, 0, 0, "line")
  pass:plane(-2.6, 0, -5, 1.618, 1.618, 0, 0, 0, 0, "line")
  pass:plane( 0,   0, -5, 1,     1.618, 0, 0, 0, 0, "line")
  pass:plane( 0,   0, -5, 1.618, 1,     0, 0, 0, 0, "line")
  pass:plane( 0,   0, -5, 1.618, 1.618, 0, 0, 0, 0, "line")
  pass:plane( 2.6, 0, -5, 1,     1.618, 0, 0, 0, 0, "line")
  pass:plane( 2.6, 0, -5, 1.618, 1,     0, 0, 0, 0, "line")
  pass:plane( 2.6, 0, -5, 1.618, 1.618, 0, 0, 0, 0, "line")
  pass:setColor(.5, .5, .5)
  pass:polygon(-2.75, 0.2, -5, -2.75, -0.2, -5, -2.45, 0, -5)
  pass:polygon(-0.05, 0.2, -5, -0.05, -0.2, -5, -0.2, 0, -5)
  pass:polygon(0.2, 0.2, -5, 0.2, -0.2, -5, 0.05, 0, -5)
  pass:plane(2.6, 0, -5, 0.35,   0.35,   0, 0, 0, 0, "fill")
  pass:setColor(.8, .4, .4, .6)
  pass:plane(-5.2 + option * 2.6, 0, -5, 1.818, 1.818, 0, 0, 0, 0, "line")
  pass:plane(-5.2 + option * 2.6, 0, -5, 1.828, 1.828, 0, 0, 0, 0, "line")
end

-- \ --------- \ --------------------------------------------------------- \ --
-- | callbacks | --------------------------------------------------------- | --
-- \ --------- \ --------------------------------------------------------- \ --

function lovr.load()
  input.load()
  level = levels.main()
  lovr.graphics.setBackgroundColor(.1, .1, .2)
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
  elseif state == "menu" then
    drawMenu(pass)
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

function input.menu()
  if state == "main" then
    lovr.graphics.setBackgroundColor(.1, .1, .2)
    source:setVolume(0)
    state = "menu"
    option = 1
  elseif state == "menu" then
    if not level.theend then
      lovr.graphics.setBackgroundColor(.5, .5, .6)
    end
    state = "main"
  elseif state == "title" then
    if not level.theend then
      lovr.graphics.setBackgroundColor(.5, .5, .6)
    end
    state = "main"
  end
end

function input.action()
  if state == "main" then
    level:action()
  elseif state == "menu" and option == 1 then
    if not level.theend then
      lovr.graphics.setBackgroundColor(.5, .5, .6)
    end
    state = "main"
  elseif state == "menu" and option == 2 then
    level:destroy()
    level = levels.main()
    if not level.theend then
      lovr.graphics.setBackgroundColor(.5, .5, .6)
    end
    state = "main"
  elseif state == "menu" and option == 3 then
    lovr.event.quit()
  elseif state == "title" then
    if not level.theend then
      lovr.graphics.setBackgroundColor(.5, .5, .6)
    end
    state = "main"
  end
end

function input.menuLeft()
  if option > 1 then option = option - 1 end
end

function input.menuRight()
  if option < 3 then option = option + 1 end
end

-- \ --------------------------------------------------------------------- \ --
-- | --------------------------------------------------------------------- | --
-- \ --------------------------------------------------------------------- \ --
