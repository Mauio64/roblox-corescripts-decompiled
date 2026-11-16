local SocialExperienceJoin = script:FindFirstAncestor("SocialExperienceJoin")
local parent = SocialExperienceJoin.Parent

local React = require(parent.React)
local UIBlox = require(parent.UIBlox)
local Localization = require(parent.Localization)
local TextKeys = require(SocialExperienceJoin.Common.TextKeys)

local useLocalization = Localization.Hooks.useLocalization
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType

return function(props)
	local v = useLocalization({
		titleText = TextKeys.UnableToJoin,
		bodyText = {
			TextKeys.NoExperienceAccess,
			name = props.userPrimaryName
		},
		confirmButtonText = TextKeys.ViewDetails,
		cancelButtonText = TextKeys.Cancel
	})

	return React.createElement(InteractiveAlert, {
		screenSize = props.screenSize,
		title = v.titleText,
		bodyText = v.bodyText,
		buttonStackInfo = {
			buttons = {
				{
					buttonType = nil,
					props = { text = v.cancelButtonText, onActivated = props.cancel }
				},
				{
					buttonType = ButtonType.PrimarySystem,
					props = {
						text = v.confirmButtonText,
						onActivated = props.openGameDetailsPeekView
					}
				}
			}
		}
	})
end
