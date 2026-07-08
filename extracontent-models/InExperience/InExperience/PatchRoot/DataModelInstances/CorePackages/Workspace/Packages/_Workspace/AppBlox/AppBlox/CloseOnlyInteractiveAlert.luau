local Parent = script:FindFirstAncestor("AppBlox").Parent
local React = require(Parent.React)
local useScreenSize = require(Parent.RobloxAppHooks).useScreenSize
local useLocalization = require(Parent.Localization).Hooks.useLocalization
local UIBlox = require(Parent.UIBlox)
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType

return function(t1: {[any]: any}) -- line: 21
	-- upvalues: useScreenSize (copy), useLocalization (copy), React (copy), InteractiveAlert (copy), ButtonType (copy)
	local v9 = useScreenSize()
	local v10 = useLocalization({
		closeButtonText = "Feature.ProfileBadges.action.close"
	})

	return React.createElement(InteractiveAlert, {
		screenSize = v9,
		title = t1.title,
		bodyText = t1.body,
		buttonStackInfo = {
			buttons = {{
				buttonType = ButtonType.Secondary,
				props = {
					onActivated = t1.closeAlert,
					text = t1.buttonText or v10.closeButtonText
				}
			}}
		},
		onCloseClicked = if not t1.showCloseButton then nil else t1.closeAlert
	})
end
