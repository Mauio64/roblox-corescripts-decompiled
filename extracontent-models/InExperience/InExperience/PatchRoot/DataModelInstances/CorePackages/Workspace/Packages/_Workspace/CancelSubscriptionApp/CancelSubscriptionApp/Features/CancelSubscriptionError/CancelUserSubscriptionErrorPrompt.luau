local CancelSubscriptionApp = script:FindFirstAncestor("CancelSubscriptionApp")
local parent = CancelSubscriptionApp.Parent
local React = require(parent.React)
local UIBlox = require(parent.UIBlox)
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local iconsstatuserror_large = UIBlox.App.ImageSet.Images["icons/status/error_large"]
local EconomyCommonCoreScriptHooks = require(parent.EconomyCommonCoreScriptHooks)
local useScreenSize = EconomyCommonCoreScriptHooks.useScreenSize

local ErrorStateEnum = require(CancelSubscriptionApp.Enums.ErrorStateEnum)

local v = {
	[ErrorStateEnum.Expiring] = "CoreScripts.CancelUserSubscriptionPrompt.ExpiringPrompt.Heading",
	[ErrorStateEnum.Unsubscribed] = "CoreScripts.CancelUserSubscriptionPrompt.UnsubscribedPrompt.Heading",
	[ErrorStateEnum.ErrorCancelling] = "CoreScripts.CancelUserSubscriptionPrompt.ErrorCancellingPrompt.Heading"
}

local v2 = {
	[ErrorStateEnum.Expiring] = "CoreScripts.CancelUserSubscriptionPrompt.ExpiringPrompt.Body",
	[ErrorStateEnum.Unsubscribed] = "CoreScripts.CancelUserSubscriptionPrompt.UnsubscribedPrompt.Body",
	[ErrorStateEnum.ErrorCancelling] = "CoreScripts.CancelUserSubscriptionPrompt.ErrorCancellingPrompt.Body"
}

local function CancelUserSubscriptionErrorPrompt(p)
	local v3 = useLocalization({
		heading = v[p.errorState],
		bodyText = v2[p.errorState],
		buttonText = "CoreScripts.CancelUserSubscriptionPrompt.Error.ButtonText"
	})

	return React.createElement(InteractiveAlert, {
		title = v3.heading,
		titleIcon = iconsstatuserror_large,
		bodyText = v3.bodyText,
		buttonStackInfo = {
			buttons = {
				{
					buttonType = ButtonType.PrimarySystem,
					props = {
						onActivated = p.onDismiss or function() end,
						text = v3.buttonText,
						delayInputSeconds = 0.75,
						[React.Tag] = "data-testid=CancelSubscriptionApp_OkButton"
					},
					isDefaultChild = true
				}
			}
		},
		position = UDim2.fromScale(0.5, 0.5),
		screenSize = useScreenSize()
	})
end

return CancelUserSubscriptionErrorPrompt
