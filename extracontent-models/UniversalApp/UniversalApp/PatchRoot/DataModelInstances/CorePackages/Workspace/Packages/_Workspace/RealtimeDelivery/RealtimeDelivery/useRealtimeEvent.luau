local RealtimeDelivery = script:FindFirstAncestor("RealtimeDelivery")

require(RealtimeDelivery.RealtimeTypes)

local useRealtimeNamespace = require(script.Parent.useRealtimeNamespace)

local function useRealtimeEvent(s1: string, s2: string, p1: ((...any) -> ...any), t1: {[any]: any}) -- line: 8
	-- upvalues: useRealtimeNamespace (copy)
	useRealtimeNamespace(s1, function(p2) -- line: 14
		-- upvalues: s2 (copy), p1 (copy)
		if p2.Type == s2 then
			p1(p2)
		end
	end, t1)
end

return useRealtimeEvent
