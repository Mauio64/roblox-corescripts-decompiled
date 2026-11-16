local parent = script.Parent.Parent

local Analytics = require(parent.Services.Analytics)
local Thunk = require(parent.Thunk)

local v = { Analytics }

local function sendEvent(p, p2)
	return Thunk.new(script.Name, v, function(_, p3)
		p3[Analytics].signalEvent(p, p2)
	end)
end

return sendEvent
