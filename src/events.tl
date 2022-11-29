require "src/camera"

global record Keyboard
  e: function()
  press: function(Keyboard, love.keyboard.Scancode)
end

local CAMERA_MOVEMENT: number = 50

local keyboard = {
  w = function()
    camera:move(point(0, -CAMERA_MOVEMENT))
  end,
  s = function()
    camera:move(point(0, CAMERA_MOVEMENT))
  end,
  a = function()
    camera:move(point(-CAMERA_MOVEMENT, 0))
  end,
  d = function()
    camera:move(point(CAMERA_MOVEMENT, 0))
  end,
  q = function()
    camera:scale(0.9)
  end,
  e = function()
    camera:scale(1.1)
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
