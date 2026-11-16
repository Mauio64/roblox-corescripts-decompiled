local RealtimeDelivery = script:FindFirstAncestor("RealtimeDelivery")
require(RealtimeDelivery.RealtimeTypes)

local useRealtimeNamespace = require(script.Parent.useRealtimeNamespace)

local function useRealtimeEvent(p: string, p2: string, callback, p3)
	useRealtimeNamespace(p, function(p4)
		if p4.Type == p2 then
			callback(p4)
		end
	end, p3)
end

return useRealtimeEvent
