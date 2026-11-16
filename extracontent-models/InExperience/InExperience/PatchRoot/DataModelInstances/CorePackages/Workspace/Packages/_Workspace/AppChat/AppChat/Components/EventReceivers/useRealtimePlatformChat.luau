local parent = script:FindFirstAncestor("AppChat").Parent
local RealtimeDelivery = require(parent.RealtimeDelivery)

require(script.Parent.CommunicationChannelsTypes)

local function useRealtimePlatformChat(callback, p)
	RealtimeDelivery.useRealtimeNamespace("CommunicationChannels", function(p2)
		if p2.ChannelVertical == "PlatformChat" then
			callback(p2)
		end
	end, p)
end

return useRealtimePlatformChat
