local FriendsLanding = script:FindFirstAncestor("FriendsLanding")

local dependencies = require(FriendsLanding.dependencies)
local roactNavigation = dependencies.RoactNavigation
local EnumScreens = require(FriendsLanding.EnumScreens)
local ModalStackNavigator = require(FriendsLanding.Navigator.ModalStackNavigator)
local toastScreen = dependencies.SocialLibraries.Components.ToastScreen

return (roactNavigation.createRobloxStackNavigator({
	{
		ModalStackNavigator = {
			screen = ModalStackNavigator,
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
