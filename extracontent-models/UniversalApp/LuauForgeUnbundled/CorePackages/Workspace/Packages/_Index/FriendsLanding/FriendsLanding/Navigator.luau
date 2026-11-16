local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/dependencies")
local roactNavigation = dependencies.RoactNavigation
local EnumScreens = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/EnumScreens")
local module3 = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/Navigator/ModalStackNavigator")
local toastScreen = dependencies.SocialLibraries.Components.ToastScreen

return (roactNavigation.createRobloxStackNavigator({
	{
		ModalStackNavigator = {
			screen = module3,
			navigationOptions = { transparent = true, absorbInputSelectable = false }
		}
	},
	{
		[EnumScreens.GenericToast] = {
			screen = toastScreen,
			navigationOptions = {
				overlayEnabled = true,
				overlayTransparency = 1,
				absorbInput = false
			}
		}
	}
}, { mode = roactNavigation.StackPresentationStyle.Overlay }))
