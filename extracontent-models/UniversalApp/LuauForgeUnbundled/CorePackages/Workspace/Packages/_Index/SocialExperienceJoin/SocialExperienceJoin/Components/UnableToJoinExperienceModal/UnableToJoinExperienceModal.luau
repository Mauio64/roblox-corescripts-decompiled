local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialExperienceJoin/React")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialExperienceJoin/UIBlox")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialExperienceJoin/Localization")
local TextKeys = require("@game/CorePackages/Workspace/Packages/_Index/SocialExperienceJoin/SocialExperienceJoin/Common/TextKeys")

local useLocalization = Localization.Hooks.useLocalization
local interactiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local buttonType = UIBlox.App.Button.Enum.ButtonType

return function(props)
	local v5 = useLocalization({
		titleText = TextKeys.UnableToJoin,
		bodyText = {
			TextKeys.NoExperienceAccess,
			name = props.userPrimaryName
		},
		confirmButtonText = TextKeys.ViewDetails,
		cancelButtonText = TextKeys.Cancel
	})

	return React.createElement(interactiveAlert, {
		screenSize = props.screenSize,
		title = v5.titleText,
		bodyText = v5.bodyText,
		buttonStackInfo = {
			buttons = {
				{
					buttonType = nil,
					props = { text = v5.cancelButtonText, onActivated = props.cancel }
				},
				{
					buttonType = buttonType.PrimarySystem,
					props = {
						text = v5.confirmButtonText,
						onActivated = props.openGameDetailsPeekView
					}
				}
			}
		}
	})
end
