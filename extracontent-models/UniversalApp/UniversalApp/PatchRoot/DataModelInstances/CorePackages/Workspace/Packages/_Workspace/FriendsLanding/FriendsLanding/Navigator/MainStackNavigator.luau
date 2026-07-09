local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local _ = FriendsLanding.Parent
local dependencies = require(FriendsLanding.dependencies)
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local RoactNavigation = dependencies.RoactNavigation
local FriendsLandingScreen = require(FriendsLanding.Components.FriendsLandingScreen)
local NavigationOptions = require(FriendsLanding.Components.FriendsLandingScreen.NavigationOptions)
local EnumScreens = require(FriendsLanding.EnumScreens)

local function getTransitionConfig() -- line: 13
	-- upvalues: UserGameSettings (copy), RoactNavigation (copy)
	if UserGameSettings.ReducedMotion then
		return RoactNavigation.StackViewTransitionConfigs.FadeInPlace
	end

	return RoactNavigation.StackViewTransitionConfigs.SlideFromRight
end

return (RoactNavigation.createRobloxStackNavigator({{
	[EnumScreens.FriendsLanding] = {
		screen = FriendsLandingScreen,
		navigationOptions = NavigationOptions
	}
}}, {
	transitionConfig = getTransitionConfig
}))
