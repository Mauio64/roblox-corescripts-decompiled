local SocialUpsell = script:FindFirstAncestor("SocialUpsell")
local SocialUpsellParent = SocialUpsell.Parent
local React = require(SocialUpsellParent.React)
local RealtimeDelivery = require(SocialUpsellParent.RealtimeDelivery)
local GetAgeVerifiedChangedSignal = require(SocialUpsell.Signals.GetAgeVerifiedChangedSignal)
local FStringAEGIS2AppChatAgeVerifiedRealtimeNamespace = require(SocialUpsellParent.SharedFlags).FStringAEGIS2AppChatAgeVerifiedRealtimeNamespace

function SocialUpsellEventReceiver(t1: {[any]: any}) -- line: 16
	-- upvalues: RealtimeDelivery (copy), FStringAEGIS2AppChatAgeVerifiedRealtimeNamespace (copy), GetAgeVerifiedChangedSignal (copy), React (copy), SocialUpsellParent (copy)
	RealtimeDelivery.useRealtimeConnectionStateChanged(FStringAEGIS2AppChatAgeVerifiedRealtimeNamespace, function(p1, p2) -- line: 19
		-- upvalues: GetAgeVerifiedChangedSignal (copy)
		if p1 == Enum.ConnectionState.Connected and p2 then
			GetAgeVerifiedChangedSignal():fire()
		end
	end, {})
	React.useEffect(function() -- line: 28
		-- upvalues: t1 (copy), SocialUpsellParent (copy)
		if t1.shouldRequestAppAgeSignals then
			require(SocialUpsellParent.AppStoreAgeSignalsManager).AppAgeSignalsManager.requestAppAgeSignals():catch(function() -- line: 31
			end)
		end
	end, { t1.shouldRequestAppAgeSignals })
	React.useEffect(function() -- line: 35
		-- upvalues: t1 (copy), GetAgeVerifiedChangedSignal (copy)
		local u10 = nil

		if t1.onAgeVerifiedChange then
			u10 = GetAgeVerifiedChangedSignal():connect(t1.onAgeVerifiedChange)
		end

		return function() -- line: 40
			-- upvalues: u10 (ref)
			if u10 then
				u10:disconnect()
			end
		end
	end, { t1.onAgeVerifiedChange })

	return nil
end

return SocialUpsellEventReceiver
