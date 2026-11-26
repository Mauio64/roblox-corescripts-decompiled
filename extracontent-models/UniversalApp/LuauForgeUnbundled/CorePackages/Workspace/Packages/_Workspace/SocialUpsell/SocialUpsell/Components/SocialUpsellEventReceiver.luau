local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/React")
local RealtimeDelivery = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/RealtimeDelivery")
local GetAgeVerifiedChangedSignal = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/SocialUpsell/Signals/GetAgeVerifiedChangedSignal")

local fStringAEGIS2AppChatAgeVerifiedRealtimeNamespace = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/SharedFlags").FStringAEGIS2AppChatAgeVerifiedRealtimeNamespace

function LUAUFORGE_MODULE_GLOBALS_cSm_SocialUpsellEventReceiver(p2): nil
	RealtimeDelivery.useRealtimeConnectionStateChanged(
		fStringAEGIS2AppChatAgeVerifiedRealtimeNamespace,
		function(p3, p4)
			if p3 == Enum.ConnectionState.Connected and p4 then
				GetAgeVerifiedChangedSignal():fire()
			end
		end,
		{}
	)

	React.useEffect(function()
		if p2.shouldRequestAppAgeSignals then
			require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/AppStoreAgeSignalsManager").AppAgeSignalsManager.requestAppAgeSignals():catch(function() end)
		end
	end, { p2.shouldRequestAppAgeSignals })

	React.useEffect(function()
		local connection = if p2.onAgeVerifiedChange then GetAgeVerifiedChangedSignal():connect(p2.onAgeVerifiedChange) else nil

		return function()
			if connection then
				connection:disconnect()
			end
		end
	end, { p2.onAgeVerifiedChange })

	return nil
end

return LUAUFORGE_MODULE_GLOBALS_cSm_SocialUpsellEventReceiver
