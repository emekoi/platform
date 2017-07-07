local _ = require "lib.lume"
local log = require "lib.log"

local Game = require "lib.classic"
local Rect = require "obj.rect"
local Color = require "obj.color"
local Input = require "obj.input"


function Game:new()
  error("use Game.init() instead")
end

function Game.init(width, height, color)
  Game.bgcolor = Color[color] and Color[color] or Color["dark-grey"]
  
  Game.width = width * G.scale
  Game.height = height * G.scale

  Game.camera = require("obj.camera")(Game, 0, 0, width, height)
  Game.framebuffer = sol.Buffer.fromBlank(Game.width, Game.height)
  Game.postbuffer = Game.framebuffer:clone()
end

function Game.update(dt)
  Game.camera:update(dt)
  -- print(Game.framebuffer:getWidth(), Game.width, Game.camera.width)
  -- handle normal keyboard input
  if Input.wasPressed("quit") then
    sol.system.quit()
  elseif Input.wasPressed("debug") then
    local mode = not sol.debug.getVisible()
    G.debug = mode
    sol.debug.clear()
    sol.debug.setVisible(G.debug and mode)
    log.trace(mode and "debug mode activated" or "debug mode deactivated")
  elseif G.debug == true and Input.wasPressed("console") then
    local mode = not sol.debug.getFocused()
    sol.debug.setFocused(G.debug and mode)
  elseif G.debug and Input.wasPressed("restart") then
    sol.onLoad()
    log.trace("game state restarted")
  end

  collectgarbage()
  collectgarbage()
end

function Game.draw()
  Game.camera:render(Game)
  
end

function Game.key(key, char)
  
end

return Game
