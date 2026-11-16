local CommercePurchaseApp = script:FindFirstAncestor("CommercePurchaseApp")
local parent = CommercePurchaseApp.Parent
local React = require(parent.React)
local EconomyCommonCoreScriptHooks = require(parent.EconomyCommonCoreScriptHooks)
local useScreenSize = EconomyCommonCoreScriptHooks.useScreenSize
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local UIBlox = require(parent.UIBlox)
local Images = UIBlox.App.ImageSet.Images

local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ErrorCodeEnum = require(CommercePurchaseApp.Enums.ErrorCodeEnum)
local FFlagAddCommerceErrors = require(CommercePurchaseApp.Flags.FFlagAddCommerceErrors)

local v = {
	[ErrorCodeEnum.NotPurchasable] = "CoreScripts.CommercePurchasePrompt.ErrorPrompt.NotPurchasable"
}

local v2 = {
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

local function CommercePurchaseError(p)
	local screenSize = useScreenSize()
	local v3 = {
		title = not FFlagAddCommerceErrors and "CoreScripts.CommercePurchasePrompt.ErrorPrompt.CantBuy" or v2[p.errorCode].title,
		errorReason = 0,
		dismissCTA = "CoreScripts.CommercePurchasePrompt.ErrorPrompt.DismissCTA"
	}
	local errorReason

	if FFlagAddCommerceErrors then
		errorReason = v2[p.errorCode].reason
	else
		errorReason = v[p.errorCode]
	end

	v3.errorReason = errorReason
	local v4 = useLocalization(v3)

	return React.createElement(InteractiveAlert, {
		title = v4.title,
		titleIcon = Images["icons/status/error_large"],
		bodyText = v4.errorReason,
		buttonStackInfo = {
			buttons = {
				{
					props = { onActivated = p.onDismiss, text = v4.dismissCTA },
					isDefaultChild = true
				}
			}
		},
		position = UDim2.fromScale(0.5, 0.5),
		screenSize = screenSize
	})
end

return CommercePurchaseError
