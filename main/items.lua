local class = require("class")
local items = {}

-- \ ------- \ ----------------------------------------------------------- \ --
-- | shaders | ----------------------------------------------------------- | --
-- \ ------- \ ----------------------------------------------------------- \ --

local defaultVertex = [[
  vec4 lovrmain()
    {
      return Projection * View * Transform * VertexPosition;
    }
]]

local defaultFragment = [[
  Constants {
    vec4 ambience;
    vec4 colorFilter;
    float fogAmount;
  };

  vec4 lovrmain()
  {
    float dist = distance(PositionWorld, CameraPositionWorld);
    vec3 norm = normalize(Normal);
    vec3 lightDir = normalize(vec3(-0.8, -0.6, -0.4));
    float diff = (dot(norm, lightDir) + 1.0) / 2.0;
    vec4 diffuse = diff * vec4(1.0, 1.0, 1.0, 1.0);
    //vec4 fogColor = vec4(
    //  min(, 0.5), min(dist, 0.5), min(dist, 0.5), 1.0);
    vec4 baseColor = Color * getPixel(ColorTexture, UV) * colorFilter;
    vec4 sceneColor = baseColor * (ambience + diffuse);
    //return sceneColor * (1.0 - fogAmount) + fogColor * fogAmount;
    return sceneColor;
  }
]]

local defaultShader = lovr.graphics.newShader(
  defaultVertex, defaultFragment, {})

-- \ --- \ --------------------------------------------------------------- \ --
-- | one | --------------------------------------------------------------- | --
-- \ --- \ --------------------------------------------------------------- \ --

function items.one(world)
  local this = {}
  local super = class.newItem(world)
  setmetatable(this, { __index = super })
  local textureOptions = { usage = { "render", "sample" } }
  local width, height = lovr.system.getWindowDimensions()

  this.filter = { "one" }
  this.texture = lovr.graphics.newTexture(width, height, textureOptions)
  this.pass = lovr.graphics.newPass(this.texture)
  this.collider:setPosition(2, 2, -6)
  super.color = { 0.6, 0.5, 0.5, 0.9 }

  function this:renderStart(player)
    super:renderStart(player)
    this.pass:reset()
    this.pass:setViewPose(1, player.camera:getPose())
    this.pass:setShader(defaultShader)
    this.pass:send("ambience", { 0.1, 0.1, 0.1, 1.0 })
    this.pass:send("colorFilter", this.color)
    this.pass:send("fogAmount", 0.1)
    this.pass:setFaceCull("back")
  end

  function this:renderGroup(group)
    super:renderGroup(group)
    group:draw(this.pass)
  end

  function this:drawRender(pass)
    super:drawRender(pass)
    pass:push()
    pass:origin()
    lovr.graphics.submit(this.pass)
    pass:fill(this.texture)
    pass:pop()
  end

  return this
end

-- \ --- \ --------------------------------------------------------------- \ --
-- | two | --------------------------------------------------------------- | --
-- \ --- \ --------------------------------------------------------------- \ --

function items.two(world)
  local this = {}
  local super = class.newItem(world)
  setmetatable(this, { __index = super })
  local textureOptions = { usage = { "render", "sample" } }
  local width, height = lovr.system.getWindowDimensions()

  this.filter = { "two" }
  this.texture = lovr.graphics.newTexture(width, height, textureOptions)
  this.pass = lovr.graphics.newPass(this.texture)
  this.collider:setPosition(-5, 2, 11)
  super.color = { 0.9, 0.5, 0.6, 0.9 }

  function this:renderStart(player)
    super:renderStart(player)
    this.pass:reset()
    this.pass:setViewPose(1, player.camera:getPose())
    this.pass:setShader(defaultShader)
    this.pass:send("ambience", {0.1, 0.1, 0.1, 1.0})
    this.pass:send("colorFilter", this.color)
    this.pass:send("fogAmount", 0.1)
    this.pass:setFaceCull("back")
  end

  function this:renderGroup(group)
    super:renderGroup(group)
    group:draw(this.pass)
  end

  function this:drawRender(pass)
    super:drawRender(pass)
    pass:push()
    pass:origin()
    lovr.graphics.submit(this.pass)
    pass:fill(this.texture)
    pass:pop()
  end

  return this
end

-- \ ----- \ ------------------------------------------------------------- \ --
-- | three | ------------------------------------------------------------- | --
-- \ ----- \ ------------------------------------------------------------- \ --

function items.three(world)
  local this = {}
  local super = class.newItem(world)
  setmetatable(this, { __index = super })
  local textureOptions = { usage = { "render", "sample" } }
  local width, height = lovr.system.getWindowDimensions()

  this.filter = { "three" }
  this.texture = lovr.graphics.newTexture(width, height, textureOptions)
  this.pass = lovr.graphics.newPass(this.texture)
  this.collider:setPosition(-38, 2, -36)
  super.color = { 0.1, 0.1, 0.8, 1.0 }

  function this:renderStart(player)
    super:renderStart(player)
    this.pass:reset()
    this.pass:setViewPose(1, player.camera:getPose())
    this.pass:setShader(defaultShader)
    this.pass:send("ambience", {0.1, 0.1, 0.1, 1.0})
    this.pass:send("colorFilter", this.color)
    this.pass:send("fogAmount", 0.1)
    this.pass:setFaceCull("back")
  end

  function this:renderGroup(group)
    super:renderGroup(group)
    group:draw(this.pass)
  end

  function this:drawRender(pass)
    super:drawRender(pass)
    pass:push()
    pass:origin()
    lovr.graphics.submit(this.pass)
    pass:fill(this.texture)
    pass:pop()
  end

  return this
end

-- \ ---- \ -------------------------------------------------------------- \ --
-- | four | -------------------------------------------------------------- | --
-- \ ---- \ -------------------------------------------------------------- \ --

function items.four(world)
  local this = {}
  local super = class.newItem(world)
  setmetatable(this, { __index = super })
  local textureOptions = { usage = { "render", "sample" } }
  local width, height = lovr.system.getWindowDimensions()

  this.filter = { "four" }
  this.texture = lovr.graphics.newTexture(width, height, textureOptions)
  this.pass = lovr.graphics.newPass(this.texture)
  this.collider:setPosition(-42, 2, 39)
  super.color = { 0.5, 0.0, 0.6, 0.9 }

  function this:renderStart(player)
    super:renderStart(player)
    this.pass:reset()
    this.pass:setViewPose(1, player.camera:getPose())
    this.pass:setShader(defaultShader)
    this.pass:send("ambience", {0.1, 0.1, 0.1, 1.0})
    this.pass:send("colorFilter", this.color)
    this.pass:send("fogAmount", 0.1)
    this.pass:setFaceCull("back")
  end

  function this:renderGroup(group)
    super:renderGroup(group)
    group:draw(this.pass)
  end

  function this:drawRender(pass)
    super:drawRender(pass)
    pass:push()
    pass:origin()
    lovr.graphics.submit(this.pass)
    pass:fill(this.texture)
    pass:pop()
  end

  return this
end

-- \ ---- \ -------------------------------------------------------------- \ --
-- | five | -------------------------------------------------------------- | --
-- \ ---- \ -------------------------------------------------------------- \ --

function items.five(world)
  local this = {}
  local super = class.newItem(world)
  setmetatable(this, { __index = super })
  local textureOptions = { usage = { "render", "sample" } }
  local width, height = lovr.system.getWindowDimensions()

  this.filter = { "five" }
  this.texture = lovr.graphics.newTexture(width, height, textureOptions)
  this.pass = lovr.graphics.newPass(this.texture)
  this.collider:setPosition(2, 10, 2)
  super.color = { 0.2, 0.5, 0.6, 1.0 }

  function this:renderStart(player)
    super:renderStart(player)
    this.pass:reset()
    this.pass:setViewPose(1, player.camera:getPose())
    this.pass:setShader(defaultShader)
    this.pass:send("ambience", {0.1, 0.1, 0.1, 1.0})
    this.pass:send("colorFilter", this.color)
    this.pass:send("fogAmount", 0.1)
    this.pass:setFaceCull("back")
  end

  function this:renderGroup(group)
    super:renderGroup(group)
    group:draw(this.pass)
  end

  function this:drawRender(pass)
    super:drawRender(pass)
    pass:push()
    pass:origin()
    lovr.graphics.submit(this.pass)
    pass:fill(this.texture)
    pass:pop()
  end

  return this
end

-- \ --- \ --------------------------------------------------------------- \ --
-- | six | --------------------------------------------------------------- | --
-- \ --- \ --------------------------------------------------------------- \ --

function items.six(world)
  local this = {}
  local super = class.newItem(world)
  setmetatable(this, { __index = super })
  local textureOptions = { usage = { "render", "sample" } }
  local width, height = lovr.system.getWindowDimensions()

  this.filter = { "six" }
  this.texture = lovr.graphics.newTexture(width, height, textureOptions)
  this.pass = lovr.graphics.newPass(this.texture)
  this.collider:setPosition(-16, 2, 55)
  super.color = { 0.4, 0.7, 0.5, 0.9 }
  this.theend = true

  function this:renderStart(player)
    super:renderStart(player)
    this.pass:reset()
    this.pass:setViewPose(1, player.camera:getPose())
    this.pass:setShader(defaultShader)
    this.pass:send("ambience", {0.1, 0.1, 0.1, 1.0})
    this.pass:send("colorFilter", this.color)
    this.pass:send("fogAmount", 0.1)
    this.pass:setFaceCull("back")
  end

  function this:renderGroup(group)
    super:renderGroup(group)
    group:draw(this.pass)
  end

  function this:drawRender(pass)
    super:drawRender(pass)
    pass:push()
    pass:origin()
    lovr.graphics.submit(this.pass)
    pass:fill(this.texture)
    pass:pop()
  end

  return this
end

-- \ --------------------------------------------------------------------- \ --
-- | --------------------------------------------------------------------- | --
-- \ --------------------------------------------------------------------- \ --

return items
