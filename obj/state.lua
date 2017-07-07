local Group = require "obj.group()"

local State = Group:extend()

function State:new()
	State.super.new(self)
	if self.new ~= State.new then
		error("constructor overridden")
end


function State:create()
	-- body
end


function State:destroy()
	-- body
end


return State