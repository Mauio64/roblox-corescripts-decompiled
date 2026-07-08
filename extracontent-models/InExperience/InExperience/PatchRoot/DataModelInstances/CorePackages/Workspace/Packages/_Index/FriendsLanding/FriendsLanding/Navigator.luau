local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local dependencies = require(FriendsLanding.dependencies)
local RoactNavigation = dependencies.RoactNavigation
local EnumScreens = require(FriendsLanding.EnumScreens)
local ModalStackNavigator = require(FriendsLanding.Navigator.ModalStackNavigator)
local ToastScreen = dependencies.SocialLibraries.Components.ToastScreen

return (RoactNavigation.createRobloxStackNavigator({
	{
		ModalStackNavigator = {
			screen = ModalStackNavigator,
			navigationOptions = {
				transparent = true,
				absorbInputSelectable = false
			}
		}
	},
	{
		[EnumScreens.GenericToast] = {
			screen = ToastScreen,
			navigationOptions = {
				overlayEnabled = true,
				overlayTransparency = 1,
				absorbInput = false
			}
		}
	}
}, {
	mode = RoactNavigation.StackPresentationStyle.Overlay
}))
