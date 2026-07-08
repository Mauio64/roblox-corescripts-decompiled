local Parent = script:FindFirstAncestor("AppChat").Parent
local RealtimeDelivery = require(Parent.RealtimeDelivery)

require(script.Parent.CommunicationChannelsTypes)

local function useRealtimePlatformChat(p1: ((...any) -> ...any), t1: {[any]: any}) -- line: 8
	-- upvalues: RealtimeDelivery (copy)
	RealtimeDelivery.useRealtimeNamespace("CommunicationChannels", function(p2) -- line: 9
		-- upvalues: p1 (copy)
		if p2.ChannelVertical == "PlatformChat" then
			p1(p2)
		end
	end, t1)
end

return useRealtimePlatformChat
