local display = require("display")

function lovr.conf(t)
  t.window.width = display.getWidth() + 1
  t.window.height = display.getHeight()
  t.modules.headset = false
  t.window.fullscreen = true
  t.window.title = 'LD58'
end
