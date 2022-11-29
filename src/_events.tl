global type Handler
  {love.keyboard.Scancode, function()}
end

global record Keyboard
  keys: {string}
  handle: function(Keyboard)
  reset: function(Keyboard)
  press: function(Keyboard)
  handlers: {Handler}
end

global keyboard = {
  ['keys'] = {},
  ['e'] = function()
    print("works")
    assert(false)
  end,
  ['handle'] = function(self: Keyboard)
    for i, key in self.keys do
      if (type(self.key) == "function") then
        self.key()
      end
    end
    self:reset()
  end,
  ['reset'] = function(self: Keyboard)
    self.keys = {}
  end
  ['press'] = function(self: Keyboard, key: love.keyboard.Scancode)
    table.insert(self.keys, key)
  end
}

global record Events
  keyboard: Keyboard
end
