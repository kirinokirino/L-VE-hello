global whats = function(...)
  local result = ""
  for i, arg in pairs{...} do
    result = string.format("%s%s", result, what(arg, 0))
  end
  return result
end

global what = function(this: any, depth: number)
  if (type(depth) == 'number' and depth > 5) then return "..." end
  if (type(depth) == 'nil') then depth = 0 end
  depth = depth + 1

  local result = ""
  local padding = string.rep("\t", depth-1)
  if (type(this) == 'number') then
    result = string.format("%s%s%s", padding, tostring(this), " is a number")
  elseif (type(this) == 'string') then
    result = string.format("%s%s%s", padding, tostring(this), " is a string")
  elseif (type(this) == 'table') then
    result = string.format("%s%s%s", padding, tostring(this), " which is a table with:\n")
    local lines = ""
    for k, v in pairs(this) do
      lines = string.format("%s%s%s:%s\n", lines, padding, k, string.sub(what(v, depth), depth))
    end
    result = string.format("%s%s", result, lines)
  elseif (type(this) == 'boolean') then
    result = string.format("%s%s%s", padding, tostring(this), " is a boolean")
  elseif (type(this) == 'nil') then
    result = string.format("%s%s%s", padding, tostring(this), " is a nil")
  elseif (type(this) == 'function') then
    result = string.format("%s%s%s", padding, tostring(this), " is a function")
  elseif (type(this) == 'userdata') then
    -- TODO
    result = string.format("%s%s%s", padding, tostring(this), " is userdata")
  elseif (type(this) == 'thread') then
    result = string.format("%s%s%s", padding, tostring(this), " is a thread")
  elseif (true) then
    print("error: ", this, type(this))
    assert(false, "couldn't recognize type")
  end
  return result
end

global record Mouse
    lmb: boolean
    lmb_pressed_at: Point
    lmb_released_at: Point
    selection: Rect
end

global record Point
    x: number
    y: number
end

global point = function(x: number, y:number): Point
  --- creates a point where x and y are numbers
  local point = {["x"] = x, ["y"] = y} as Point
  setmetatable(point, {["__tostring"] = function(v) return string.format("point (%s, %s)", v.x, v.y) end})
  return point
end

global record Rect
    x: number
    y: number
    w: number
    h: number
    points: function(Rect): {Point, Point, Point, Point}
end

global draw_rect = function(rect: Rect)
  love.graphics.rectangle('line', rect.x, rect.y, rect.w, rect.h)
end

local rect2 = function(p1: Point, p2: Point): Rect
  --- creates a rectangle from two points
  assert(type(p1.x) == "number")
  assert(type(p1.y) == "number")
  assert(type(p2.x) == "number")
  assert(type(p2.y) == "number")
  local min_x = math.min(p1.x, p2.x)
  local min_y = math.min(p1.y, p2.y)
  local max_x = math.max(p1.x, p2.x)
  local max_y = math.max(p1.y, p2.y)
  return {
    ["x"] = min_x, ["y"] = min_y, ["w"] =  max_x - min_x, ["h"] = max_y - min_y,
    points = function(self: Rect): {Point, Point, Point, Point}
      return {
        point(self.x, self.y),
        point(self.x + self.w, self.y),
        point(self.x + self.w, self.y + self.h),
        point(self.x, self.y + self.h)
      }
    end,
    }
end

local rect1 = function(p: Point, w: number, h: number): Rect
  --- creates a rectangle with origin of point p and dimensions of w and h
  --- p: origin point (top left corner)
  --- w, h: rectangle dimensions (numbers)
  assert(type(p.x) == "number")
  assert(type(p.y) == "number")
  assert(type(w) == "number")
  assert(type(h) == "number")
  return {
    ["x"] = p.x, ["y"] = p.y, ["w"] = w, ["h"] = h,
    points = function(self: Rect): {Point, Point, Point, Point}
      return {
        point(self.x, self.y),
        point(self.x + self.w, self.y),
        point(self.x + self.w, self.y + self.h),
        point(self.x, self.y + self.h)
      }
    end,
    }
end

global rect = function(a1: Point, a2: any, a3: any): Rect

  local rect
  if (type(a2) == 'number' and type(a2) == 'number') then
    -- treating a2 as width and a3 as height
    rect = rect1(a1, a2 as number, a3 as number)
  else
    assert(type(a3) == 'nil')
    -- treating a1 and a2 as points
    rect = rect2(a1, a2 as Point)
    end
  setmetatable(rect, {["__tostring"] = function(v) return string.format("rect at (%s, %s) of size (%s, %s)", v.x, v.y, v.w, v.h) end})
  return rect
end

global record PhysicsObject
    userdata
    body: love.physics.Body
    shape: love.physics.PolygonShape
    fixture: love.physics.Fixture
end

global polygon = function(world: love.physics.World, points: {Point}): PhysicsObject
  --- creates a physical polygon and adds it to the world
  local polygon: PhysicsObject = {}
  local pts: {number} = {}
  local origin: Point = {}
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
  polygon.shape = love.physics.newPolygonShape(table.unpack(pts))
  polygon.fixture = love.physics.newFixture(polygon.body, polygon.shape as love.physics.Shape)
  return polygon
end
