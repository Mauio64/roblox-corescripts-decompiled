local React = require("@game/CorePackages/Workspace/Packages/_Workspace/VerifiedParentalConsentDialog/React")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/VerifiedParentalConsentDialog/UIBlox")
local interactiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/VerifiedParentalConsentDialog/Localization").Hooks.useLocalization

local buttonType = UIBlox.App.Button.Enum.ButtonType

local function AlertPrompt(props)
	local v5 = useLocalization({
		GoToSettings = "Common.VerifiedParentalConsent.Action.GoToSettings",
		Cancel = "Common.VerifiedParentalConsent.Action.Cancel",
		Close = "Common.VerifiedParentalConsent.Action.Close"
	})

	local createElement = React.createElement
	local v7 = {
		title = props.title,
		titleIcon = props.titleIcon,
		bodyText = props.bodyText,
		buttonStackInfo = 0,
		position = 0,
		screenSize = 0,
		middleContent = 0
	}
	local v8 = { buttons = 0 }
	local v9

	if props.isActionable then
		v9 = { nil, nil }
		local v10 = { buttonType = buttonType.PrimarySystem, props = 0 }

		local v12 = if props.onAction then props.onAction else props.onDismiss
		v10.props = { onActivated = v12, text = v5.GoToSettings }

		v9[1], v9[2] = v10, {
	props = { onActivated = props.onDismiss, text = v5.Cancel }
}
	else
		v9 = {
			{
				props = { onActivated = props.onDismiss, text = v5.Close }
			}
		}
	end

	v8.buttons = v9
	v7.buttonStackInfo = v8

	v7.position = UDim2.fromScale(0.5, 0.5)
	v7.screenSize = props.screenSize
	v7.middleContent = props.middleContent
	return createElement(interactiveAlert, v7)
end

return AlertPrompt
