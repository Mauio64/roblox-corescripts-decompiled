local ParentParent = script.Parent.Parent
local Analytics = require(ParentParent.Services.Analytics)
local Thunk = require(ParentParent.Thunk)
local t1 = { Analytics }

local function sendEvent(p1, p2) -- line: 11
	-- upvalues: Thunk (copy), t1 (copy), Analytics (copy)
	return Thunk.new(script.Name, t1, function(_, p4) -- line: 12
		-- upvalues: Analytics (copy), p1 (copy), p2 (copy)
		p4[Analytics].signalEvent(p1, p2)
	end)
end

return sendEvent
