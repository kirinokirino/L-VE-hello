require "src/mylib"
global love = require "love"

local world: love.physics.World
local shapes: {PhysicsObject}
local bar: PhysicsObject
local mouse: Mouse

function love.load()
  world = love.physics.newWorld(0, 300)

  mouse = {
    ['lmb'] = false,
    ['lmb_pressed_at'] = point(0,0),
    ['lmb_released_at'] = point(0,0),
    ['selection'] = rect(point(0,0), 0, 0),
  }

  shapes = {}
  local triangle: PhysicsObject = {}
  triangle.body = love.physics.newBody(world, 150, 0, 'dynamic')
  triangle.body:setMass(32)
  triangle.shape = love.physics.newPolygonShape(100,100,200,100,200,200)
  triangle.fixture = love.physics.newFixture(triangle.body, triangle.shape as love.physics.Shape)
  triangle.fixture:setRestitution(0.6)
  triangle.body:setAngularVelocity(1.5)
  table.insert(shapes, triangle)

  local bar_origin = point(-20,450)
  local bar_rect = rect(bar_origin, 700, 50)
  bar = polygon(world, bar_rect:points())
  bar.body:setType('static')
end

love.update = function(delta: number)
  world:update(delta)
end

love.draw = function()
  for _i, shape in ipairs(shapes) do
    love.graphics.polygon('line', shape.body:getWorldPoints(shape.shape:getPoints()))
  end
  love.graphics.polygon('line', bar.body:getWorldPoints(bar.shape:getPoints()))
  if (mouse.lmb) then
    draw_rect(mouse.selection)
  end
end

love.keypressed = function(key: love.keyboard.KeyConstant, scancode: love.keyboard.Scancode, isrepeat: boolean)
  print(key, " was pressed, scancode: ", scancode)
  if (isrepeat) then return end
  if (key == 'escape') then love.event.quit() end
  if (key == '\'') then
    print(whats(shapes))
  end
end

love.mousepressed = function(x: number, y: number, button: number, _istouch: boolean, _presses: number)
  if (button == 1) then
    mouse.lmb = true
    mouse.lmb_pressed_at = point(x, y)
    mouse.selection.x = x
    mouse.selection.y = y
  end
end

love.mousemoved = function(x: number, y: number, _dx: number, _dy: number, _istouch: boolean)
  if (mouse.lmb) then
    mouse.selection = rect(mouse.lmb_pressed_at, point(x, y))
  end
end

love.mousereleased = function(x: number, y: number, button: number, _istouch: boolean, _presses: number)
  if (button == 1) then
    mouse.lmb = false
    mouse.lmb_released_at = point(x, y)

    local new_rect = rect(mouse.lmb_pressed_at, mouse.lmb_released_at)
    local poly = polygon(world, new_rect:points())
    table.insert(shapes, poly)
    mouse.selection = rect(point(0,0), 0, 0)
  end
end
