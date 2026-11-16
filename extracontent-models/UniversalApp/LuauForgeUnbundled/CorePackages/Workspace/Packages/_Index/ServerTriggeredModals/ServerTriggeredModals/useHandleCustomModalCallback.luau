local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/React")
local SocialUpsell = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/SocialUpsell")

local CustomModalType = require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/CustomModalType")
local reportModalImpression = require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/reportModalImpression")
local sendModalImpressionEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/ServerTriggeredModalImpressions").sendModalImpressionEvent

local socialUpsellType = SocialUpsell.Enums.SocialUpsellType
local upsellEntrySurfaceType = SocialUpsell.Analytics.Enum.UpsellEntrySurfaceType
local upsellComponent = SocialUpsell.Analytics.Enum.UpsellComponent
local useSocialUpsellOverlayController = SocialUpsell.Hooks.useSocialUpsellOverlayController

return function(p2, p3)
	local v5 = useSocialUpsellOverlayController(false)

	return React.useCallback(function(p4)
		if p4.modalType == CustomModalType.SocialFaceAgeEstimationUpsell then
			v5.openSocialOverlay(socialUpsellType.FacialAgeEstimation, {
				upsellEntrySurface = upsellEntrySurfaceType.Homepage,
				upsellEntryComponent = upsellComponent.Modal,
				onMounted = function()
					reportModalImpression(p3, p4.modalId, p4.modalType)
					sendModalImpressionEvent(p4.modalId, p4.modalType)
				end
			})
		end
	end, { p3, p2, v5.openSocialOverlay })
end
