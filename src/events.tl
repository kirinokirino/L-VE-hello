require "src/camera"

global record Keyboard
  e: function()
  press: function(Keyboard, love.keyboard.Scancode)
end

local CAMERA_MOVEMENT: number = 50

local keyboard = {
  e = function()
    camera:move(point(0, -CAMERA_MOVEMENT))
  end,
  d = function()
    camera:move(point(0, CAMERA_MOVEMENT))
  end,
  s = function()
    camera:move(point(-CAMERA_MOVEMENT, 0))
  end,
  f = function()
    camera:move(point(CAMERA_MOVEMENT, 0))
  end,
  press = function(self: Keyboard, scancode: love.keyboard.Scancode)
    if self[scancode] then
      self[scancode]()
    else
      print("no handler for scancode ", scancode)
    end
  end
}

global record Events
  keyboard: Keyboard
end

global events = {
  keyboard = keyboard
}
