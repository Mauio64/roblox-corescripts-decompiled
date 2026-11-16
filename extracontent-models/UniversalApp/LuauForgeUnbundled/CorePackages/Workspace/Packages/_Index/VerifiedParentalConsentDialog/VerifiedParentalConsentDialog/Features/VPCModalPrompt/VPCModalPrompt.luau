local React = require("@game/CorePackages/Workspace/Packages/_Workspace/VerifiedParentalConsentDialog/React")

local images = require("@game/CorePackages/Workspace/Packages/_Workspace/VerifiedParentalConsentDialog/UIBlox").App.ImageSet.Images
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/VerifiedParentalConsentDialog/Localization").Hooks.useLocalization

local AlertPrompt = require("@game/CorePackages/Workspace/Packages/_Index/VerifiedParentalConsentDialog/VerifiedParentalConsentDialog/Components/AlertPrompt")
require("@game/CorePackages/Workspace/Packages/_Index/VerifiedParentalConsentDialog/VerifiedParentalConsentDialog/VPCModalType")

local function VPCModalPrompt(props)
	local v6 = useLocalization({
		title = "Common.VerifiedParentalConsent.Label.AskParent",
		message = ({
			EnablePurchase = { props.isActionable and "Common.VerifiedParentalConsent.Description.SpendingRestrictionWithSettings" or "Common.VerifiedParentalConsent.Description.SpendingRestrictionWithoutSettings" }
		})[props.modalType]
	})

	return React.createElement(AlertPrompt, {
		title = v6.title,
		titleIcon = images["icons/graphic/lock_xxlarge"],
		bodyText = v6.message,
		onDismiss = props.onDismiss,
		isActionable = props.isActionable,
		screenSize = props.screenSize,
		onAction = props.onAction
	})
end

return VPCModalPrompt
