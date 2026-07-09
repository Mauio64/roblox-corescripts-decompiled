local Parent = script:FindFirstAncestor("CancelSubscriptionApp").Parent
local React = require(Parent.React)
local UIBlox = require(Parent.UIBlox)
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local useLocalization = require(Parent.Localization).Hooks.useLocalization
local useScreenSize = require(Parent.EconomyCommonCoreScriptHooks).useScreenSize
local t1 = {
	heading = "CoreScripts.CancelUserSubscriptionPrompt.RequestPrompt.Heading",
	bodyText = "CoreScripts.CancelUserSubscriptionPrompt.RequestPrompt.Body",
	noButtonText = "CoreScripts.CancelUserSubscriptionPrompt.RequestPrompt.DontCancelButton",
	yesButtonText = "CoreScripts.CancelUserSubscriptionPrompt.RequestPrompt.YesCancelButton"
}

local function CancelUserSubscriptionRequestPrompt(t2: {[any]: any}) -- line: 24
	-- upvalues: useLocalization (copy), t1 (copy), React (copy), InteractiveAlert (copy), ButtonType (copy), useScreenSize (copy)
	local v11 = useLocalization(t1)
	local v12 = v11.bodyText:gsub("{date}", t2.expirationDate)

	return React.createElement(InteractiveAlert, {
		title = v11.heading,
		bodyText = v12,
		buttonStackInfo = {
			forcedFillDirection = Enum.FillDirection.Horizontal,
			buttons = {
				{
					isDefaultChild = true,
					props = {
						onActivated = t2.onCancel or function() -- line: 35
						end,
						text = v11.noButtonText,
						delayInputSeconds = 0.75,
						[React.Tag] = "data-testid=CancelSubscriptionApp_DontCancelButton"
					}
				},
				{
					isDefaultChild = false,
					buttonType = ButtonType.PrimarySystem,
					props = {
						onActivated = t2.onConfirm or function() -- line: 45
						end,
						text = v11.yesButtonText,
						delayInputSeconds = 0.75,
						[React.Tag] = "data-testid=CancelSubscriptionApp_YesCancelButton"
					}
				}
			}
		},
		position = UDim2.fromScale(0.5, 0.5),
		screenSize = useScreenSize()
	})
end

return CancelUserSubscriptionRequestPrompt
