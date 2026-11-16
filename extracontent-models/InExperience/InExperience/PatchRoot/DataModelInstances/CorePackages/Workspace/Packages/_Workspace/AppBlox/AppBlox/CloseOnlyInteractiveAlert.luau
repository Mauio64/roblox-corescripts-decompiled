local parent = script:FindFirstAncestor("AppBlox").Parent
local React = require(parent.React)
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useScreenSize = RobloxAppHooks.useScreenSize
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local UIBlox = require(parent.UIBlox)
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType

return function(props)
	local screenSize = useScreenSize()

	local v = useLocalization({ closeButtonText = "Feature.ProfileBadges.action.close" })

	local createElement = React.createElement
	local v2 = {
		screenSize = screenSize,
		title = props.title,
		bodyText = props.body,
		buttonStackInfo = {
			buttons = {
				{
					buttonType = ButtonType.Secondary,
					props = {
						onActivated = props.closeAlert,
						text = props.buttonText or v.closeButtonText
					}
				}
			}
		},
		onCloseClicked = 0
	}
	local onCloseClicked

	if props.showCloseButton then
		onCloseClicked = props.closeAlert
	end

	v2.onCloseClicked = onCloseClicked
	return createElement(InteractiveAlert, v2)
end
