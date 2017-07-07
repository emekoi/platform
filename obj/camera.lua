local _ = require "lib.lume"
local Object = require "lib.classic"

local Camera = Object:extend()

function Camera:new(game, x, y, width, height)
  self.game = game
  self:set(x, y, width, height)
  self.sx, self.sy = G.scale, G.scale
  self.shake_time = 0
  self.shake = 0
end


function Camera:set(x, y, w, h)
  self.x = x or self.x
  self.y = y or self.y
  self.width = w or self.width
  self.height = h or self.height
end


function Camera:shake(time, amount)
  self.shake_time = time
  self.shake = amount
end


function Camera:move(dx, dy)
  local x = self.x + (dx or 0)
  local y = self.y + (dy or 0)
  self:goTo(x, y)
  print(self.x, self.y)

end


function Camera:goTo(x, y)
  self:setX(x or self.x)
  self:setY(y or self.y)
end


function Camera:zoom(dsx, dsy)
  local dsx = dsx or 1
  self.sx = self.sx * dsx
  self.sy = self.sy * (dsy or dsx)
end


function Camera:setX(x)
  local x = _.clamp(x, 0, self.game.width - self.width) or x
  self:set(x, nil, nil, nil)
end


function Camera:setY(y)
  local y = _.clamp(y, 0, self.game.height - self.height) or y
  self:set(nil, y, nil, nil)
end


function Camera:setScale(sx, sy)
  self.sx = sx or self.sx
  self.sy = sy or self.sy
end


function Camera:update(dt)
  if self.shake_time ~= 0 then
    self.shake_time = self.shake_time - dt
    if self.shake_time <= 0 then
      self.shake_time = 0
      self.shake = 0
    end
  end
end


function Camera:render()
  local rect = { x = self.x, y = self.y, w = self.width, h = self.height }
  -- print(rect.x, rect.y, rect.w, rect.h)
  self.game.postbuffer = self.game.framebuffer:clone()
  self.game.framebuffer:clear(unpack(self.game.bgcolor))
  self.game.framebuffer:reset()

  if not (self.shake_time <= 0) then
    sol.graphics.draw(self.game.postbuffer,
      _.random() * self.shake,
      _.random() * self.shake, rect, nil, self.sx, self.sy)
    return 
  end
  sol.graphics.draw(self.game.postbuffer, 0, 0, rect, nil, self.sx, self.sy)
end


return Camera
