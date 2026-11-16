local parent = script:FindFirstAncestor("CancelSubscriptionApp").Parent
local React = require(parent.React)
local UIBlox = require(parent.UIBlox)
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local EconomyCommonCoreScriptHooks = require(parent.EconomyCommonCoreScriptHooks)
local useScreenSize = EconomyCommonCoreScriptHooks.useScreenSize

local v = {
	heading = "CoreScripts.CancelUserSubscriptionPrompt.RequestPrompt.Heading",
	bodyText = "CoreScripts.CancelUserSubscriptionPrompt.RequestPrompt.Body",
	noButtonText = "CoreScripts.CancelUserSubscriptionPrompt.RequestPrompt.DontCancelButton",
	yesButtonText = "CoreScripts.CancelUserSubscriptionPrompt.RequestPrompt.YesCancelButton"
}

local function CancelUserSubscriptionRequestPrompt(props)
	local v2 = useLocalization(v)
	local bodyText = v2.bodyText:gsub("{date}", props.expirationDate)
	return React.createElement(InteractiveAlert, {
		title = v2.heading,
		bodyText = bodyText,
		buttonStackInfo = {
			forcedFillDirection = Enum.FillDirection.Horizontal,
			buttons = {
				{
					props = {
						onActivated = props.onCancel or function() end,
						text = v2.noButtonText,
						delayInputSeconds = 0.75,
						[React.Tag] = "data-testid=CancelSubscriptionApp_DontCancelButton"
					},
					isDefaultChild = true
				},
				{
					buttonType = ButtonType.PrimarySystem,
					props = {
						onActivated = props.onConfirm or function() end,
						text = v2.yesButtonText,
						delayInputSeconds = 0.75,
						[React.Tag] = "data-testid=CancelSubscriptionApp_YesCancelButton"
					},
					isDefaultChild = false
				}
			}
		},
		position = UDim2.fromScale(0.5, 0.5),
		screenSize = useScreenSize()
	})
end

return CancelUserSubscriptionRequestPrompt
