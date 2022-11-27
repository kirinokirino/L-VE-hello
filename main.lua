require "mylib"

local world = love.physics.newWorld(0, 100)

local triangle = {}
triangle.body = love.physics.newBody(world, 200, 200, 'dynamic')
triangle.body:setMass(32)
triangle.shape = love.physics.newPolygonShape(100,100,200,100,200,200)
triangle.fixture = love.physics.newFixture(triangle.body, triangle.shape)

local bar_origin = point(50,50)
print("origin - ", bar_origin)
local bar_rect = rect(bar_origin, 300, 50)
print("rect - ", bar_rect)
local bar = polygon(world, bar_rect:points())

love.update = function(delta)
  world:update(delta)
end

love.draw = function(delta)
  local success, value = pcall(love.graphics.rect, rect(point(100, 100), 100, 100))
  love.graphics.polygon('line', triangle.body:getWorldPoints(triangle.shape:getPoints()))
  love.graphics.polygon('line', bar.body:getWorldPoints(bar.shape:getPoints()))
end

love.keypressed = function(key, scancode, isrepeat) 
  if (isrepeat) then return end
  if (key == 'escape') then love.event.quit() end
  
end
