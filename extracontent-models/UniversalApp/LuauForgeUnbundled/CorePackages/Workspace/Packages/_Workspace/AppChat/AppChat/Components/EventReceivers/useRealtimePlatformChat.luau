local RealtimeDelivery = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RealtimeDelivery")

require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/EventReceivers/CommunicationChannelsTypes")

local function useRealtimePlatformChat(callback, p2)
	RealtimeDelivery.useRealtimeNamespace("CommunicationChannels", function(p3)
		if p3.ChannelVertical == "PlatformChat" then
			callback(p3)
		end
	end, p2)
end

return useRealtimePlatformChat
