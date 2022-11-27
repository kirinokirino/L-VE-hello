require "mylib"

local world, triangle, bar;

function love.load()
  world = love.physics.newWorld(0, 100)

  triangle = {}
  triangle.body = love.physics.newBody(world, 150, 0, 'dynamic')
  triangle.body:setMass(32)
  triangle.shape = love.physics.newPolygonShape(100,100,200,100,200,200)
  triangle.fixture = love.physics.newFixture(triangle.body, triangle.shape)

  local bar_origin = point(-20,450)
  local bar_rect = rect(bar_origin, 700, 50)
  bar = polygon(world, bar_rect:points())
  bar.body:setType('static')
end

love.update = function(delta)
  world:update(delta)
end

love.draw = function(delta)
  love.graphics.polygon('line', triangle.body:getWorldPoints(triangle.shape:getPoints()))
  love.graphics.polygon('line', bar.body:getWorldPoints(bar.shape:getPoints()))
end

love.keypressed = function(key, scancode, isrepeat) 
  if (isrepeat) then return end
  if (key == 'escape') then love.event.quit() end
  
end
