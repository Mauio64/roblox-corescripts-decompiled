local NotificationService = game:GetService("NotificationService")

local AppCommonLib = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/AppCommonLib")
local RealtimeDelivery = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/RealtimeDelivery")

local fStringAEGIS2AppChatAgeVerifiedRealtimeNamespace = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/SharedFlags").FStringAEGIS2AppChatAgeVerifiedRealtimeNamespace

local robloxEventReceiver = RealtimeDelivery.RobloxEventReceiver.new(NotificationService)

local signal = AppCommonLib.Signal

local v5 = nil

return function()
	if not v5 then
		v5 = signal.new()

		if
			fStringAEGIS2AppChatAgeVerifiedRealtimeNamespace
			and #fStringAEGIS2AppChatAgeVerifiedRealtimeNamespace > 0
		then
			robloxEventReceiver:observeEvent(fStringAEGIS2AppChatAgeVerifiedRealtimeNamespace, function(p2)
				if v5 then
					v5:fire(p2)
				end
			end)
		end
	end

	return v5
end
