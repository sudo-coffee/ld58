local mouse = require("lib/lovr-mouse")
local gc = require("lib/game_controller")
local input = {}

-- \ ------- \ ----------------------------------------------------------- \ --
-- | private | ----------------------------------------------------------- | --
-- \ ------- \ ----------------------------------------------------------- \ --

local mouseVec = lovr.math.newVec2()
local steps = 0
local movesSinceWindowFocused = 0
local padLeft = false
local padRight = false
local padA = false
local padB = false
local padX = false
local padY = false
local padDLeft = false
local padDRight = false
local padStart = false

-- \ --------- \ --------------------------------------------------------- \ --
-- | callbacks | --------------------------------------------------------- | --
-- \ --------- \ --------------------------------------------------------- \ --

function input.action() end
function input.exit() end
function input.menuLeft() end
function input.menuRight() end

-- \ ------ \ ------------------------------------------------------------ \ --
-- | public | ------------------------------------------------------------ | --
-- \ ------ \ ------------------------------------------------------------ \ --

function input.load()
  mouse.setRelativeMode(true) -- Toggle this for menus
  mouse.setPosition(0, 0)
end

function input.update(dt)
  if not lovr.system.isWindowFocused() then
    movesSinceWindowFocused = 0
  end
  steps = steps - 1
  if steps == 0 then
    mouseVec.x = 0
    mouseVec.y = 0
  end
  local padX = gc.getGamepadState(1).axes[GAMEPAD_AXIS_LEFT_X]
  if not padRight and padX > 0.8 then
    padRight = true
    input.menuRight()
  elseif padRight and padX < 0.4 then
    padRight = false
  end
  if not padLeft and padX < -0.8 then
    padLeft = true
    input.menuLeft()
  elseif padLeft and padX > -0.4 then
    padLeft = false
  end
  local buttons = gc.getGamepadState(1).buttons
  if not padA and buttons[GAMEPAD_BUTTON_A] == 1 then
    padA = true
    input.action()
  elseif padA and buttons[GAMEPAD_BUTTON_A] == 0 then
    padA = false
  end
  if not padB and buttons[GAMEPAD_BUTTON_B] == 1 then
    padB = true
    input.action()
  elseif padB and buttons[GAMEPAD_BUTTON_B] == 0 then
    padB = false
  end
  if not padX and buttons[GAMEPAD_BUTTON_X] == 1 then
    padX = true
    input.action()
  elseif padX and buttons[GAMEPAD_BUTTON_X] == 0 then
    padX = false
  end
  if not padY and buttons[GAMEPAD_BUTTON_Y] == 1 then
    padY = true
    input.action()
  elseif padY and buttons[GAMEPAD_BUTTON_Y] == 0 then
    padY = false
  end
  if not padDLeft and buttons[GAMEPAD_BUTTON_DPAD_LEFT] == 1 then
    padDLeft = true
    input.menuLeft()
  elseif padDLeft and buttons[GAMEPAD_BUTTON_DPAD_LEFT] == 0 then
    padDLeft = false
  end
  if not padDRight and buttons[GAMEPAD_BUTTON_DPAD_RIGHT] == 1 then
    padDRight = true
    input.menuRight()
  elseif padDRight and buttons[GAMEPAD_BUTTON_DPAD_RIGHT] == 0 then
    padDRight = false
  end
  if not padStart and buttons[GAMEPAD_BUTTON_START] == 1 then
    padStart = true
    input.exit()
  elseif padStart and buttons[GAMEPAD_BUTTON_START] == 0 then
    padStart = false
  end
end

function input.mousemoved(x, y, dx, dy)
  if movesSinceWindowFocused >= 3 then
    mouseVec.x = dx
    mouseVec.y = dy
    steps = 3
  end
  movesSinceWindowFocused = movesSinceWindowFocused + 1
end

function input.keypressed(key, scancode, repeated)
  if key == "space" then input.action() end
  if key == "escape" then input.exit() end
  if key == "return" then input.action() end
  if key == "a" then input.menuLeft() end
  if key == "left" then input.menuLeft() end
  if key == "d" then input.menuRight() end
  if key == "right" then input.menuRight() end
end

function input.mousepressed(x, y, button)
  if button == 1 then input.action() end
end

function input.getTurnVector()
  local gamepad = gc.getGamepadState(1)
  local padVec = lovr.math.vec2()
  local turnVec = nil
  padVec.x = gamepad.axes[GAMEPAD_AXIS_RIGHT_X]
  padVec.y = gamepad.axes[GAMEPAD_AXIS_RIGHT_Y]
  if padVec:length() > 0.1 then
    turnVec = padVec / 32
  else
    turnVec = mouseVec / 192
  end
  return turnVec.x, turnVec.y
end

function input.getMoveVector()
  local gamepad = gc.getGamepadState(1)
  local padVec = lovr.math.vec2()
  local keyVec = lovr.math.vec2()
  local moveVec = nil
  if lovr.system.isKeyDown("d", "right") then keyVec.x = keyVec.x + 1 end
  if lovr.system.isKeyDown("a", "left") then keyVec.x = keyVec.x - 1 end
  if lovr.system.isKeyDown("s", "down") then keyVec.y = keyVec.y + 1 end
  if lovr.system.isKeyDown("w", "up") then keyVec.y = keyVec.y - 1 end
  padVec.x = gamepad.axes[GAMEPAD_AXIS_LEFT_X]
  padVec.y = gamepad.axes[GAMEPAD_AXIS_LEFT_Y]
  if padVec:length() > 0.1 then
    moveVec = padVec
  else
    moveVec = keyVec
  end
  if moveVec:length() > 1 then
    moveVec:normalize()
  end
  return moveVec.x, moveVec.y
end

-- \ --------------------------------------------------------------------- \ --
-- | --------------------------------------------------------------------- | --
-- \ --------------------------------------------------------------------- \ --

return input
