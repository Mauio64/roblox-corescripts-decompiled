local SocialUpsell = script:FindFirstAncestor("SocialUpsell")
local parent = SocialUpsell.Parent

local React = require(parent.React)
local RealtimeDelivery = require(parent.RealtimeDelivery)
local GetAgeVerifiedChangedSignal = require(SocialUpsell.Signals.GetAgeVerifiedChangedSignal)

local SharedFlags = require(parent.SharedFlags)
local FStringAEGIS2AppChatAgeVerifiedRealtimeNamespace = SharedFlags.FStringAEGIS2AppChatAgeVerifiedRealtimeNamespace

function SocialUpsellEventReceiver(p): nil
	RealtimeDelivery.useRealtimeConnectionStateChanged(
		FStringAEGIS2AppChatAgeVerifiedRealtimeNamespace,
		function(p2, p3)
			if p2 == Enum.ConnectionState.Connected and p3 then
				GetAgeVerifiedChangedSignal():fire()
			end
		end,
		{}
	)

	React.useEffect(function()
		if p.shouldRequestAppAgeSignals then
			local AppStoreAgeSignalsManager = require(parent.AppStoreAgeSignalsManager)
			AppStoreAgeSignalsManager.AppAgeSignalsManager.requestAppAgeSignals():catch(function() end)
		end
	end, { p.shouldRequestAppAgeSignals })

	React.useEffect(function()
		local connection

		if p.onAgeVerifiedChange then
			connection = GetAgeVerifiedChangedSignal():connect(p.onAgeVerifiedChange)
		else
			connection = nil
		end

		return function()
			if connection then
				connection:disconnect()
			end
		end
	end, { p.onAgeVerifiedChange })

	return nil
end

return SocialUpsellEventReceiver
