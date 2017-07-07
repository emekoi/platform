local _ = require "lib.lume"
local Entity = require "core.entity"

local Tile = Entity:extend()
local TileMap = Entity:extend()

function Tile:new(filename, tilesize, index, cache)
  Tile.super.new(self)
  if cache then
    self.image = cache.image
    self.frames = cache.frames
    self.width, self.height = tilesize, tilesize
  else
    self:loadImage(filename, tilesize, tilesize)
  end
  self.frame = index
  self.solid = true
  self.moves = false
end

TileMap.Tile = Tile

function TileMap:new()
  TileMap.super.new(self)
  self.solid = false
end

function TileMap:loadArray(array, width, imageFile, tileSize)
  if #array % width ~= 0 then
      error("expected array to be divisible by width")
  end
  self.data = _.clone(array)
  self.widthInTiles = width
  self.heightInTiles = #array / width
  self.tileSize = tileSize
  self.tiles = {}
  local cache = Tile(imageFile, tileSize, 1)
  for i = 1, math.huge do
    local tile = Tile(imageFile, tileSize, i, cache)
    table.insert(self.tiles, tile)
    if i == #tile.frames then
      break
    end
  end
  self.width = self.widthInTiles * self.tileSize
  self.height = self.heightInTiles * self.tileSize
end

function TileMap:loadTMX(filename, imageFile)
  local text = sol.fs.read(filename)
  local ptn = '"csv">(.-)<'
  local s = text:match(ptn)
  assert(s, "tile layer does not exist")
  local data = _.map(_.split(s, ","), tonumber)
  local width = tonumber(text:match('width="(.-)"'))
  local tileSize = tonumber(text:match('tilewidth="(.-)"'))
  if not imageFile then
    imageFile = text:match('image source="(.-)"'):gsub("%.%.", "data")
  end
  self:loadArray(data, width, imageFile, tileSize)
  return self
end

function TileMap:getTile(x, y)
  local t = self.tiles[self.data[x + y * self.widthInTiles + 1]]
  if t then
    t.x, t.y = x * self.tileSize + self.x, y * self.tileSize + self.y
    return t
  end
end

function TileMap:eachOverlappingTile(r, fn, revx, revy, ...)
  local sx = math.floor((r:left()    - self.x) / self.tileSize)
  local sy = math.floor((r:top()     - self.y) / self.tileSize)
  local ex = math.floor((r:right()   - self.x) / self.tileSize)
  local ey = math.floor((r:bottom()  - self.y) / self.tileSize)
  sx, sy = math.max(sx, 0), math.max(sy, 0)
  ex = math.min(ex, self.widthInTiles - 1)
  ey = math.min(ey, self.heightInTiles - 1)
  if revx then sx, ex = ex, sx end
  if revy then sy, ey = ey, sy end
  for y = sy, ey, (revy and -1 or 1) do
    for x = sx, ex, (revx and -1 or 1) do
      local t = self:getTile(x, y)
      if t then fn(t, ...) end
    end
  end
end

function TileMap:update(dt)
  TileMap.super.update(self, dt)
  _.each(self.tiles, "update", dt)
end

function TileMap:draw()
  -- self:eachOverlappingTile(Tile.draw)
end

return TileMap
