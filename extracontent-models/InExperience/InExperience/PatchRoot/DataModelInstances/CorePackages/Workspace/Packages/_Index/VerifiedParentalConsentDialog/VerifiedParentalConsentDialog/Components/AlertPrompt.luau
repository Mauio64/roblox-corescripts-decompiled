local parent = script:FindFirstAncestor("VerifiedParentalConsentDialog").Parent
local React = require(parent.React)
local UIBlox = require(parent.UIBlox)
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local ButtonType = UIBlox.App.Button.Enum.ButtonType

local function AlertPrompt(props)
	local v = useLocalization({
		GoToSettings = "Common.VerifiedParentalConsent.Action.GoToSettings",
		Cancel = "Common.VerifiedParentalConsent.Action.Cancel",
		Close = "Common.VerifiedParentalConsent.Action.Close"
	})

	local createElement = React.createElement
	local v2 = {
		title = props.title,
		titleIcon = props.titleIcon,
		bodyText = props.bodyText,
		buttonStackInfo = 0,
		position = 0,
		screenSize = 0,
		middleContent = 0
	}
	local buttonStackInfo = { buttons = 0 }
	local buttons

	if props.isActionable then
		buttons = { nil, nil }
		local v3 = { buttonType = ButtonType.PrimarySystem, props = 0 }
		local onActivated

		if props.onAction then
			onActivated = props.onAction
		else
			onActivated = props.onDismiss
		end

		v3.props = { onActivated = onActivated, text = v.GoToSettings }

		buttons[1], buttons[2] = v3, {
	props = { onActivated = props.onDismiss, text = v.Cancel }
}
	else
		buttons = {
			{
				props = { onActivated = props.onDismiss, text = v.Close }
			}
		}
	end

	buttonStackInfo.buttons = buttons
	v2.buttonStackInfo = buttonStackInfo

	v2.position = UDim2.fromScale(0.5, 0.5)
	v2.screenSize = props.screenSize
	v2.middleContent = props.middleContent
	return createElement(InteractiveAlert, v2)
end

return AlertPrompt
