local VerifiedParentalConsentDialog = script:FindFirstAncestor("VerifiedParentalConsentDialog")
local VerifiedParentalConsentDialogParent = VerifiedParentalConsentDialog.Parent
local React = require(VerifiedParentalConsentDialogParent.React)
local Images = require(VerifiedParentalConsentDialogParent.UIBlox).App.ImageSet.Images
local useLocalization = require(VerifiedParentalConsentDialogParent.Localization).Hooks.useLocalization
local AlertPrompt = require(VerifiedParentalConsentDialog.Components.AlertPrompt)

require(VerifiedParentalConsentDialog.VPCModalType)

local function VPCModalPrompt(t1: {[any]: any}) -- line: 22
	-- upvalues: useLocalization (copy), React (copy), AlertPrompt (copy), Images (copy)
	local t2 = {
		EnablePurchase = { not t1.isActionable and "Common.VerifiedParentalConsent.Description.SpendingRestrictionWithoutSettings" or "Common.VerifiedParentalConsent.Description.SpendingRestrictionWithSettings" }
	}
	local v10 = useLocalization({
		title = "Common.VerifiedParentalConsent.Label.AskParent",
		message = t2[t1.modalType]
	})

	return React.createElement(AlertPrompt, {
		title = v10.title,
		titleIcon = Images["icons/graphic/lock_xxlarge"],
		bodyText = v10.message,
		onDismiss = t1.onDismiss,
		isActionable = t1.isActionable,
		screenSize = t1.screenSize,
		onAction = t1.onAction
	})
end

return VPCModalPrompt
