local CancelSubscriptionApp = script:FindFirstAncestor("CancelSubscriptionApp")
local CancelSubscriptionAppParent = CancelSubscriptionApp.Parent
local React = require(CancelSubscriptionAppParent.React)
local UIBlox = require(CancelSubscriptionAppParent.UIBlox)
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local useLocalization = require(CancelSubscriptionAppParent.Localization).Hooks.useLocalization
local v8 = UIBlox.App.ImageSet.Images["icons/status/error_large"]
local useScreenSize = require(CancelSubscriptionAppParent.EconomyCommonCoreScriptHooks).useScreenSize
local ErrorStateEnum = require(CancelSubscriptionApp.Enums.ErrorStateEnum)
local t1 = {
	[ErrorStateEnum.Expiring] = "CoreScripts.CancelUserSubscriptionPrompt.ExpiringPrompt.Heading",
	[ErrorStateEnum.Unsubscribed] = "CoreScripts.CancelUserSubscriptionPrompt.UnsubscribedPrompt.Heading",
	[ErrorStateEnum.ErrorCancelling] = "CoreScripts.CancelUserSubscriptionPrompt.ErrorCancellingPrompt.Heading"
}
local t2 = {
	[ErrorStateEnum.Expiring] = "CoreScripts.CancelUserSubscriptionPrompt.ExpiringPrompt.Body",
	[ErrorStateEnum.Unsubscribed] = "CoreScripts.CancelUserSubscriptionPrompt.UnsubscribedPrompt.Body",
	[ErrorStateEnum.ErrorCancelling] = "CoreScripts.CancelUserSubscriptionPrompt.ErrorCancellingPrompt.Body"
}

local function CancelUserSubscriptionErrorPrompt(t3: {[any]: any}) -- line: 30
	-- upvalues: useLocalization (copy), t1 (copy), t2 (copy), React (copy), InteractiveAlert (copy), v8 (copy), ButtonType (copy), useScreenSize (copy)
	local v15 = useLocalization({
		buttonText = "CoreScripts.CancelUserSubscriptionPrompt.Error.ButtonText",
		heading = t1[t3.errorState],
		bodyText = t2[t3.errorState]
	})

	return React.createElement(InteractiveAlert, {
		title = v15.heading,
		titleIcon = v8,
		bodyText = v15.bodyText,
		buttonStackInfo = {
			buttons = {{
				isDefaultChild = true,
				buttonType = ButtonType.PrimarySystem,
				props = {
					onActivated = t3.onDismiss or function() -- line: 46
					end,
					text = v15.buttonText,
					delayInputSeconds = 0.75,
					[React.Tag] = "data-testid=CancelSubscriptionApp_OkButton"
				}
			}}
		},
		position = UDim2.fromScale(0.5, 0.5),
		screenSize = useScreenSize()
	})
end

return CancelUserSubscriptionErrorPrompt
