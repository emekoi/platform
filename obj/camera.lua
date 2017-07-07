local _ = require "lib.lume"
local Object = require "lib.classic"

local Camera = Object:extend()

function Camera:new(x, y, width, width)
  self:set(x, y, width, height)

  self.scale = { x = 2, x = 2 }

  self.shake_time = 0
  self.shake = 0
end

function Camera:shake(time, amount)
  self.shake_time = time
  self.shake = amount
end

function Camera:move(dx, dy)
  local x = self.x + (dx or 0)
  local y = self.y + (dy or 0)
  self:goTo(x, y)
end

-- function Camera:zoom(dsx, dsy)
--   local dsx = dsx or 1
--   self.scale.x = self.scale.x * dsx
--   self.scale.y = self.scale.y * (dsy or dsx)
-- end

-- function Camera:setX(x)
--   local x = self.bounds and _.clamp(x, 0, self.bounds.width) or x
--   self:set(x, nil, nil, nil)
-- end

-- function Camera:setY(y)
--   local y = self.bounds and _.clamp(y, 0, self.bounds.height) or y
--   self:set(nil, y, nil, nil)
-- end

-- function Camera:setScale(sx, sy)
--   self.sx = sx or self.sx
--   self.sy = sy or self.sy
-- end

function Camera:getBounds()
  return (table.unpack or unpack)(self.bounds)
end

function Camera:setBounds(w, h)
  self.bounds = {
    width = w,
    height = h
  }
end

function Camera:update(dt)
  if self.shakeTimer ~= 0 then
    self.shakeTimer = self.shakeTimer - dt
    if self.shakeTimer <= 0 then
      self.shakeTimer = 0
      self.shakeAmount = 0
    end
  end
end

function Camera:render()
  Game.postbuffer = Game.framebuffer:clone()
  Game.framebuffer:clear(unpack(Game.bgcolor))
  Game.framebuffer:reset()

  if self.shakeTimer >= 1 then
    sol.graphics.draw(Game.postbuffer,
      _.random() * cam.shake,
      _.random() * cam.shake, nil, nil, self.sx, self.sy)
    return 
  end
  sol.graphics.draw(Game.postbuffer, 0, 0, nil, nil, self.sx, self.sy)
end

return Camera
