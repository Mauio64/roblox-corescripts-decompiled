local NotificationService = game:GetService("NotificationService")
local Parent = script:FindFirstAncestor("SocialUpsell").Parent
local AppCommonLib = require(Parent.AppCommonLib)
local RealtimeDelivery = require(Parent.RealtimeDelivery)
local FStringAEGIS2AppChatAgeVerifiedRealtimeNamespace = require(Parent.SharedFlags).FStringAEGIS2AppChatAgeVerifiedRealtimeNamespace
local v6 = RealtimeDelivery.RobloxEventReceiver.new(NotificationService)
local Signal = AppCommonLib.Signal
local u8 = nil

return function() -- line: 21
	-- upvalues: u8 (ref), Signal (copy), FStringAEGIS2AppChatAgeVerifiedRealtimeNamespace (copy), v6 (copy)
	if not u8 then
		u8 = Signal.new()

		if FStringAEGIS2AppChatAgeVerifiedRealtimeNamespace and #FStringAEGIS2AppChatAgeVerifiedRealtimeNamespace > 0 then
			v6:observeEvent(FStringAEGIS2AppChatAgeVerifiedRealtimeNamespace, function(p1) -- line: 28
				-- upvalues: u8 (ref)
				if u8 then
					u8:fire(p1)
				end
			end)
		end
	end

	return u8
end
