
love.graphics.rect = function(rect)
  love.graphics.rectangle('line', rect.x, rect.y, rect.w, rect.h)
end

point = function(x, y)
  --- creates a point where x and y are numbers
  assert(type(x) == "number")
  assert(type(y) == "number")
  return {["x"] = x, ["y"] = y}
end

rect = function(p, w, h)
  --- creates a rectangle with origin of point p and dimensions of w and h
  --- p: origin point (top left corner)
  --- w, h: rectangle dimensions (numbers)
  assert(type(p.x) == "number")
  assert(type(p.y) == "number")
  assert(type(w) == "number")
  assert(type(h) == "number")
  return {
    ["x"] = p.x, ["y"] = p.y, ["w"] = w, ["h"] = h, 
    points = function(self) 
      return { 
        point(self.x, self.y), 
        point(self.x + self.w, self.y),
        point(self.x + self.w, self.y + self.h), 
        point(self.x, self.y + self.h)
      }
    end
    }
end

polygon = function(world, points)
  --- creates a physical polygon and adds it to the world
  print("points - ", points)
  local polygon = {}
  local pts = {}
  assert(type(points) == "table")
  for i, point in ipairs(points) do
    assert(type(point.x) == "number")
    assert(type(point.y) == "number")
    pts[i*2-1] = point.x
    pts[i*2] = point.y
  end
  polygon.body = love.physics.newBody(world, pts[0], pts[1], 'dynamic')
  polygon.shape = love.physics.newPolygonShape(unpack(pts))
  polygon.fixture = love.physics.newFixture(polygon.body, polygon.shape)
  return polygon
end 