local mouse = require("lib/lovr-mouse")
local gc = require("lib/game_controller")
local input = {}

-- \ ------- \ ----------------------------------------------------------- \ --
-- | private | ----------------------------------------------------------- | --
-- \ ------- \ ----------------------------------------------------------- \ --

local mouseVec = lovr.math.newVec2()
local steps = 0
local movesSinceWindowFocused = 0

-- \ --------- \ --------------------------------------------------------- \ --
-- | callbacks | --------------------------------------------------------- | --
-- \ --------- \ --------------------------------------------------------- \ --

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
end

function input.mousemoved(x, y, dx, dy)
  if movesSinceWindowFocused >= 3 then
    mouseVec.x = dx
    mouseVec.y = dy
    steps = 3
  end
  movesSinceWindowFocused = movesSinceWindowFocused + 1
end

-- \ ------ \ ------------------------------------------------------------ \ --
-- | public | ------------------------------------------------------------ | --
-- \ ------ \ ------------------------------------------------------------ \ --

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
  print(padVec:length())
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
