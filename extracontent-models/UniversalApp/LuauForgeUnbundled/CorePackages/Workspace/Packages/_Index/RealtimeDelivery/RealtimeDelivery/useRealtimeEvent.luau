require("@game/CorePackages/Workspace/Packages/_Index/RealtimeDelivery/RealtimeDelivery/RealtimeTypes")

local useRealtimeNamespace = require("@game/CorePackages/Workspace/Packages/_Index/RealtimeDelivery/RealtimeDelivery/useRealtimeNamespace")

local function useRealtimeEvent(p2, p3, callback, p4)
	useRealtimeNamespace(p2, function(p5)
		if p5.Type == p3 then
			callback(p5)
		end
	end, p4)
end

return useRealtimeEvent
