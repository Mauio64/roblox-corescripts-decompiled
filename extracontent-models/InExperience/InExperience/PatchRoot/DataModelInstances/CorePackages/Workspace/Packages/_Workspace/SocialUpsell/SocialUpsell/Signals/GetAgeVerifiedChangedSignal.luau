local NotificationService = game:GetService("NotificationService")

local parent = script:FindFirstAncestor("SocialUpsell").Parent

local AppCommonLib = require(parent.AppCommonLib)
local RealtimeDelivery = require(parent.RealtimeDelivery)

local SharedFlags = require(parent.SharedFlags)
local FStringAEGIS2AppChatAgeVerifiedRealtimeNamespace = SharedFlags.FStringAEGIS2AppChatAgeVerifiedRealtimeNamespace

local robloxEventReceiver = RealtimeDelivery.RobloxEventReceiver.new(NotificationService)

local Signal = AppCommonLib.Signal

local v = nil

return function()
	if not v then
		v = Signal.new()

		if
			FStringAEGIS2AppChatAgeVerifiedRealtimeNamespace
			and #FStringAEGIS2AppChatAgeVerifiedRealtimeNamespace > 0
		then
			robloxEventReceiver:observeEvent(FStringAEGIS2AppChatAgeVerifiedRealtimeNamespace, function(p)
				if v then
					v:fire(p)
				end
			end)
		end
	end

	return v
end
