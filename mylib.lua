
draw_rect = function(rect)
  love.graphics.rectangle('line', rect.x, rect.y, rect.w, rect.h)
end

point = function(x, y)
  --- creates a point where x and y are numbers
  assert(type(x) == "number")
  assert(type(y) == "number")
  return {["x"] = x, ["y"] = y}
end

rect = function(a1, a2, a3) 
  if (type(a2) == 'number') then
    -- treating a2 as width and a3 as height
    return rect1(a1, a2, a3)
  else
    assert(type(a3) == 'nil')
    -- treating a1 and a2 as points
    return rect2(a1, a2)
    end
end

rect2 = function(p1, p2)
  --- creates a rectangle from two points
  assert(type(p1.x) == "number")
  assert(type(p1.y) == "number")
  assert(type(p2.x) == "number")
  assert(type(p2.y) == "number")
  local min_x, min_y, max_x, max_y;
  min_x = math.min(p1.x, p2.x)
  min_y = math.min(p1.y, p2.y)
  max_x = math.max(p1.x, p2.x)
  max_y = math.max(p1.y, p2.y)
  return {
    ["x"] = min_x, ["y"] = min_y, ["w"] =  max_x - min_x, ["h"] = max_y - min_y, 
    points = function(self) 
      return { 
        point(self.x, self.y), 
        point(self.x + self.w, self.y),
        point(self.x + self.w, self.y + self.h), 
        point(self.x, self.y + self.h)
      }
    end,
    }
end

rect1 = function(p, w, h)
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
    end,
    }
end

polygon = function(world, points)
  --- creates a physical polygon and adds it to the world
  local polygon = {}
  local pts = {}
  local origin = {}
  assert(type(points) == "table")
  for i, point in ipairs(points) do
    assert(type(point.x) == "number")
    assert(type(point.y) == "number")
    if (i == 1) then
      origin = point
    end
    pts[i*2-1] = point.x - origin.x
    pts[i*2] = point.y - origin.y
  end
  
  polygon.body = love.physics.newBody(world, origin.x, origin.y, 'dynamic')
  polygon.shape = love.physics.newPolygonShape(unpack(pts))
  polygon.fixture = love.physics.newFixture(polygon.body, polygon.shape)
  return polygon
end 