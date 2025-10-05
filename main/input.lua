local mouse = require("lib/lovr-mouse")
local input = {}

-- \ ------- \ ----------------------------------------------------------- \ --
-- | private | ----------------------------------------------------------- | --
-- \ ------- \ ----------------------------------------------------------- \ --

local turnVec = lovr.math.newVec3()
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
    turnVec.x = 0
    turnVec.y = 0
    turnVec.z = 0
  end
end

function input.mousemoved(x, y, dx, dy)
  if movesSinceWindowFocused >= 2 then
    turnVec.x = dy / 256
    turnVec.y = dx / 256
    turnVec.z = 0
    steps = 2
  end
  movesSinceWindowFocused = movesSinceWindowFocused + 1
end

-- \ ------ \ ------------------------------------------------------------ \ --
-- | public | ------------------------------------------------------------ | --
-- \ ------ \ ------------------------------------------------------------ \ --

function input.getTurnVector()
  return turnVec.x, turnVec.y, turnVec.z
end

function input.getMoveVector()
  local moveVec = lovr.math.vec3()
  if lovr.system.isKeyDown("d", "right") then moveVec.x = moveVec.x + 1 end
  if lovr.system.isKeyDown("a", "left") then moveVec.x = moveVec.x - 1 end
  if lovr.system.isKeyDown("s", "down") then moveVec.z = moveVec.z + 1 end
  if lovr.system.isKeyDown("w", "up") then moveVec.z = moveVec.z - 1 end
  if moveVec:length() > 0 then
    moveVec:normalize()
  end
  return moveVec.x, moveVec.y, moveVec.z
end

-- \ --------------------------------------------------------------------- \ --
-- | --------------------------------------------------------------------- | --
-- \ --------------------------------------------------------------------- \ --

return input
