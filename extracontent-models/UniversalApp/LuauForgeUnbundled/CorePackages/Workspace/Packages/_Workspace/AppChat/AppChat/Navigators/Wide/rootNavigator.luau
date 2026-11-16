local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Roact")
local RoactNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactNavigation")

local EnumScreens = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/EnumScreens")
local ToastScreen = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/Toast/ToastScreen")
local FFlagAppChatDisableAbsorbInputSelectable = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatDisableAbsorbInputSelectable")

local chatLandingWithDialogsNavigator = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Navigators/Wide/chatLandingWithDialogsNavigator")

local extended = Roact.Component:extend("ChatLandingWithDialogsNavigatorConnector")
extended.router = chatLandingWithDialogsNavigator.router

function extended.render(p2)
	return Roact.createElement(chatLandingWithDialogsNavigator, p2.props)
end

return RoactNavigation.createRobloxStackNavigator({
	{ ChatLandingWithDialogs = extended },
	{
		[EnumScreens.RoactChatToast] = {
			screen = ToastScreen,
			navigationOptions = {
				overlayEnabled = true,
				overlayTransparency = 1,
				absorbInput = false
			}
		}
	}
}, {
	defaultNavigationOptions = FFlagAppChatDisableAbsorbInputSelectable and { absorbInputSelectable = false } or nil,
	mode = RoactNavigation.StackPresentationStyle.Overlay
})
