local class = {}

-- \ ------- \ ----------------------------------------------------------- \ --
-- | Helpers | ----------------------------------------------------------- | --
-- \ ------- \ ----------------------------------------------------------- \ --

local function doGroupsMatch(camera, object)
  local match = false
  for _, cameraGroup in ipairs(camera.groups) do
    for _, objectGroup in ipairs(object.groups) do
      if objectGroup == cameraGroup then
        match = true
        break
      end
    end
    if match then
      break
    end
  end
  return match
end

function class.renderObjects(pass, objects, cameras)
  for _, camera in ipairs(camera) do
    local cameraPass = camera:getPass()
    camera:startCameraDraw(cameraPass)
    for _, object in ipairs(objects) do
      if doGroupsMatch(camera, object) then
        camera:startObjectDraw(cameraPass)
        object:draw(cameraPass)
        camera:endObjectDraw(cameraPass)
      end
    end
    camera:endCameraDraw(cameraPass)
  end
end

-- \ ------ \ ------------------------------------------------------------ \ --
-- | object | ------------------------------------------------------------ | --
-- \ ------ \ ------------------------------------------------------------ \ --

function class.newObject()
  local this = {}

  this.transform = lovr.math.newMat4()
  this.groups = {} -- strings

  function this:draw(pass) end
  function this:update(dt) end

  return this
end

-- \ ------ \ ------------------------------------------------------------ \ --
-- | camera | ------------------------------------------------------------ | --
-- \ ------ \ ------------------------------------------------------------ \ --

function class.newCamera()
  local this = {}

  local textureOptions = { usage = { "render", "transfer" } }

  this.transform = lovr.math.newMat4()
  this.groups = {} -- strings
  this.texture = lovr.graphics.newTexture(800, 800, textureOptions)
  this.enabled = false
  this.shader = nil
  this.pass = nil

  function this:getPass()
    this.texture:clear()
    local pass = lovr.graphics.newPass(this.texture)
    return pass
  end

  function this:update(dt) end

  return this
end

-- \ ----- \ ------------------------------------------------------------- \ --
-- | Level | ------------------------------------------------------------- | --
-- \ ----- \ ------------------------------------------------------------- \ --

function class.newLevel()
  local this = {}

  this.objects = {}
  this.cameras = {}

  function this:draw(pass)
    for _, camera in ipairs(this.cameras) do
      if camera.enabled then
        local cameraPass = camera:getPass()
        for _, object in ipairs(this.objects) do
          if doGroupsMatch(camera, object) then
            object:draw(cameraPass)
          end
        end
      end
    end
    -- combine textures here
  end

  function this:update(dt)
    for _, object in ipairs(this.objects) do
      object:update(dt)
    end
    for _, camera in ipairs(this.cameras) do
      camera:update(dt)
    end
  end

  return this
end

-- \ --------------------------------------------------------------------- \ --
-- | --------------------------------------------------------------------- | --
-- \ --------------------------------------------------------------------- \ --

return class
