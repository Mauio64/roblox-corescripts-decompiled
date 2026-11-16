local parent = script.Parent.Parent
local Thunk = require(parent.Thunk)
local Analytics = require(parent.Services.Analytics)

local v = { Analytics }

local function SendCounter(p)
	return Thunk.new(script.Name, v, function(_, p2)
		p2[Analytics].sendCounter(p)
	end)
end

return SendCounter
