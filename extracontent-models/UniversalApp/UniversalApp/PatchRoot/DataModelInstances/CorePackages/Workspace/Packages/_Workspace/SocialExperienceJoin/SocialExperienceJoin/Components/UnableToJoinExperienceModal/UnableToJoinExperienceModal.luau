local SocialExperienceJoin = script:FindFirstAncestor("SocialExperienceJoin")
local SocialExperienceJoinParent = SocialExperienceJoin.Parent
local React = require(SocialExperienceJoinParent.React)
local UIBlox = require(SocialExperienceJoinParent.UIBlox)
local Localization = require(SocialExperienceJoinParent.Localization)
local TextKeys = require(SocialExperienceJoin.Common.TextKeys)
local useLocalization = Localization.Hooks.useLocalization
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType

return function(t1: {[any]: any}) -- line: 21
	-- upvalues: useLocalization (copy), TextKeys (copy), React (copy), InteractiveAlert (copy), ButtonType (copy)
	local v11 = useLocalization({
		titleText = TextKeys.UnableToJoin,
		bodyText = {
			TextKeys.NoExperienceAccess,
			name = t1.userPrimaryName
		},
		confirmButtonText = TextKeys.ViewDetails,
		cancelButtonText = TextKeys.Cancel
	})

	return React.createElement(InteractiveAlert, {
		screenSize = t1.screenSize,
		title = v11.titleText,
		bodyText = v11.bodyText,
		buttonStackInfo = {
			buttons = {
				{
					buttonType = nil,
					props = {
						text = v11.cancelButtonText,
						onActivated = t1.cancel
					}
				},
				{
					buttonType = ButtonType.PrimarySystem,
					props = {
						text = v11.confirmButtonText,
						onActivated = t1.openGameDetailsPeekView
					}
				}
			}
		}
	})
end
