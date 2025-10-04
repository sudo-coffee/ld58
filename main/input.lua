local mouse = require("lib/lovr-mouse")
local input = {}

-- \ ------- \ ----------------------------------------------------------- \ --
-- | private | ----------------------------------------------------------- | --
-- \ ------- \ ----------------------------------------------------------- \ --

local turnVec = lovr.math.newVec3()
local mouseMoved = 0

-- \ --------- \ --------------------------------------------------------- \ --
-- | callbacks | --------------------------------------------------------- | --
-- \ --------- \ --------------------------------------------------------- \ --

function input.load()
  mouse.setRelativeMode(true) -- Toggle this for menus
end

function input.update(dt)
  mouseMoved = mouseMoved - 1
  if mouseMoved == 0 then
    turnVec.x = 0
    turnVec.y = 0
    turnVec.z = 0
  end
end

function input.mousemoved(x, y, dx, dy)
  turnVec.x = dy / 256
  turnVec.y = dx / 256
  turnVec.z = 0
  mouseMoved = 2
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
