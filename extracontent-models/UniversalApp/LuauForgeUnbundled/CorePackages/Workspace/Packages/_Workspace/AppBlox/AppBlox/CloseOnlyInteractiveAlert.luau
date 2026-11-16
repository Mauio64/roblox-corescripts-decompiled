local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/React")
local useScreenSize = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/RobloxAppHooks").useScreenSize
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/Localization").Hooks.useLocalization
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/UIBlox")
local interactiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local buttonType = UIBlox.App.Button.Enum.ButtonType

return function(props)
	local v5 = useScreenSize()

	local v6 = useLocalization({
		closeButtonText = "Feature.ProfileBadges.action.close"
	})

	local createElement = React.createElement
	local v8 = {
		screenSize = v5,
		title = props.title,
		bodyText = props.body,
		buttonStackInfo = {
			buttons = {
				{
					buttonType = buttonType.Secondary,
					props = {
						onActivated = props.closeAlert,
						text = props.buttonText or v6.closeButtonText
					}
				}
			}
		},
		onCloseClicked = 0
	}

	local v9 = if props.showCloseButton then props.closeAlert else nil
	v8.onCloseClicked = v9
	return createElement(interactiveAlert, v8)
end
