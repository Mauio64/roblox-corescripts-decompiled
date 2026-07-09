local CommercePurchaseApp = script:FindFirstAncestor("CommercePurchaseApp")
local CommercePurchaseAppParent = CommercePurchaseApp.Parent
local React = require(CommercePurchaseAppParent.React)
local useScreenSize = require(CommercePurchaseAppParent.EconomyCommonCoreScriptHooks).useScreenSize
local useLocalization = require(CommercePurchaseAppParent.Localization).Hooks.useLocalization
local UIBlox = require(CommercePurchaseAppParent.UIBlox)
local Images = UIBlox.App.ImageSet.Images
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ErrorCodeEnum = require(CommercePurchaseApp.Enums.ErrorCodeEnum)
local FFlagAddCommerceErrors = require(CommercePurchaseApp.Flags.FFlagAddCommerceErrors)
local t1 = {
	[ErrorCodeEnum.NotPurchasable] = "CoreScripts.CommercePurchasePrompt.ErrorPrompt.NotPurchasable"
}
local t2 = {
	[ErrorCodeEnum.NotPurchasable] = {
		title = "CoreScripts.CommercePurchasePrompt.ProductNotAvailable",
		reason = "CoreScripts.CommercePurchasePrompt.ErrorPrompt.NotPurchasable"
	},
	[ErrorCodeEnum.DeviceNotSupported] = {
		title = "CoreScripts.CommercePurchasePrompt.ErrorPrompt.Title.DeviceNotSupported",
		reason = "CoreScripts.CommercePurchasePrompt.ErrorPrompt.Body.DeviceNotSupported"
	},
	[ErrorCodeEnum.AccountNotSupported] = {
		title = "CoreScripts.CommercePurchasePrompt.ErrorPrompt.Title.AccountNotSupported",
		reason = "CoreScripts.CommercePurchasePrompt.ErrorPrompt.Body.AccountNotSupported"
	}
}

local function CommercePurchaseError(t3: {[any]: any}) -- line: 39
	-- upvalues: useScreenSize (copy), useLocalization (copy), FFlagAddCommerceErrors (copy), t2 (copy), t1 (copy), React (copy), InteractiveAlert (copy), Images (copy)
	local v15 = useScreenSize()
	local v16 = useLocalization({
		dismissCTA = "CoreScripts.CommercePurchasePrompt.ErrorPrompt.DismissCTA",
		title = not FFlagAddCommerceErrors and "CoreScripts.CommercePurchasePrompt.ErrorPrompt.CantBuy" or t2[t3.errorCode].title,
		errorReason = if not FFlagAddCommerceErrors then t1[t3.errorCode] else t2[t3.errorCode].reason
	})

	return React.createElement(InteractiveAlert, {
		title = v16.title,
		titleIcon = Images["icons/status/error_large"],
		bodyText = v16.errorReason,
		buttonStackInfo = {
			buttons = {{
				isDefaultChild = true,
				props = {
					onActivated = t3.onDismiss,
					text = v16.dismissCTA
				}
			}}
		},
		position = UDim2.fromScale(0.5, 0.5),
		screenSize = v15
	})
end

return CommercePurchaseError
