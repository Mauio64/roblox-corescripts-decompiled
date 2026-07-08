local ServerTriggeredModals = script:FindFirstAncestor("ServerTriggeredModals")
local ServerTriggeredModalsParent = ServerTriggeredModals.Parent
local React = require(ServerTriggeredModalsParent.React)
local SocialUpsell = require(ServerTriggeredModalsParent.SocialUpsell)
local CustomModalType = require(ServerTriggeredModals.CustomModalType)
local reportModalImpression = require(ServerTriggeredModals.reportModalImpression)
local sendModalImpressionEvent = require(ServerTriggeredModals.sendModalImpressionEvent)
local SocialUpsellType = SocialUpsell.Enums.SocialUpsellType
local UpsellEntrySurfaceType = SocialUpsell.Analytics.Enum.UpsellEntrySurfaceType
local UpsellComponent = SocialUpsell.Analytics.Enum.UpsellComponent
local useSocialUpsellOverlayController = SocialUpsell.Hooks.useSocialUpsellOverlayController

return function(p1, p2) -- line: 16
	-- upvalues: useSocialUpsellOverlayController (copy), React (copy), CustomModalType (copy), SocialUpsellType (copy), UpsellEntrySurfaceType (copy), UpsellComponent (copy), reportModalImpression (copy), sendModalImpressionEvent (copy)
	local v14 = useSocialUpsellOverlayController(false)

	return React.useCallback(function(p3) -- line: 19
		-- upvalues: CustomModalType (copy), v14 (copy), SocialUpsellType (copy), UpsellEntrySurfaceType (copy), UpsellComponent (copy), reportModalImpression (copy), p2 (copy), sendModalImpressionEvent (copy)
		if p3.modalType == CustomModalType.SocialFaceAgeEstimationUpsell then
			v14.openSocialOverlay(SocialUpsellType.FacialAgeEstimation, {
				upsellEntrySurface = UpsellEntrySurfaceType.Homepage,
				upsellEntryComponent = UpsellComponent.Modal,
				onMounted = function() -- line: 24
					-- upvalues: reportModalImpression (copy), p2 (copy), p3 (copy), sendModalImpressionEvent (copy)
					reportModalImpression(p2, p3.modalId, p3.modalType)
					sendModalImpressionEvent(p3.modalId, p3.modalType)
				end
			})
		end
	end, {
		p2,
		p1,
		v14.openSocialOverlay
	})
end
