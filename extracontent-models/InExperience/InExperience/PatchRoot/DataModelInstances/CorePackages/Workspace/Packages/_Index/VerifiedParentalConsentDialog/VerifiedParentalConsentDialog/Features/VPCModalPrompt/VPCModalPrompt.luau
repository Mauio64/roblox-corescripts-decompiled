local VerifiedParentalConsentDialog = script:FindFirstAncestor("VerifiedParentalConsentDialog")
local parent = VerifiedParentalConsentDialog.Parent
local React = require(parent.React)

local UIBlox = require(parent.UIBlox)
local Images = UIBlox.App.ImageSet.Images
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local AlertPrompt = require(VerifiedParentalConsentDialog.Components.AlertPrompt)
require(VerifiedParentalConsentDialog.VPCModalType)

local function VPCModalPrompt(props)
	local v = useLocalization({
		title = "Common.VerifiedParentalConsent.Label.AskParent",
		message = ({
			EnablePurchase = { props.isActionable and "Common.VerifiedParentalConsent.Description.SpendingRestrictionWithSettings" or "Common.VerifiedParentalConsent.Description.SpendingRestrictionWithoutSettings" }
		})[props.modalType]
	})

	return React.createElement(AlertPrompt, {
		title = v.title,
		titleIcon = Images["icons/graphic/lock_xxlarge"],
		bodyText = v.message,
		onDismiss = props.onDismiss,
		isActionable = props.isActionable,
		screenSize = props.screenSize,
		onAction = props.onAction
	})
end

return VPCModalPrompt
