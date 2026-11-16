local ServerTriggeredModals = script:FindFirstAncestor("ServerTriggeredModals")
local parent = ServerTriggeredModals.Parent

local React = require(parent.React)
local SocialUpsell = require(parent.SocialUpsell)

local CustomModalType = require(ServerTriggeredModals.CustomModalType)
local reportModalImpression = require(ServerTriggeredModals.reportModalImpression)
local ServerTriggeredModalImpressions = require(parent.ServerTriggeredModalImpressions)
local sendModalImpressionEvent = ServerTriggeredModalImpressions.sendModalImpressionEvent

local SocialUpsellType = SocialUpsell.Enums.SocialUpsellType
local UpsellEntrySurfaceType = SocialUpsell.Analytics.Enum.UpsellEntrySurfaceType
local UpsellComponent = SocialUpsell.Analytics.Enum.UpsellComponent
local useSocialUpsellOverlayController = SocialUpsell.Hooks.useSocialUpsellOverlayController

return function(p, p2)
	local v = useSocialUpsellOverlayController(false)

	return React.useCallback(function(p3)
		if p3.modalType == CustomModalType.SocialFaceAgeEstimationUpsell then
			v.openSocialOverlay(SocialUpsellType.FacialAgeEstimation, {
				upsellEntrySurface = UpsellEntrySurfaceType.Homepage,
				upsellEntryComponent = UpsellComponent.Modal,
				onMounted = function()
					reportModalImpression(p2, p3.modalId, p3.modalType)
					sendModalImpressionEvent(p3.modalId, p3.modalType)
				end
			})
		end
	end, { p2, p, v.openSocialOverlay })
end
