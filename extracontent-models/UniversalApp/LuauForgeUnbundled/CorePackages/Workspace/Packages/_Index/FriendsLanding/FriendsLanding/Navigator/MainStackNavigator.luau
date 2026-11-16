local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/dependencies")

local UserGameSettings = UserSettings():GetService("UserGameSettings")
local roactNavigation = dependencies.RoactNavigation
local FriendsLandingScreen = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/Components/FriendsLandingScreen")

local NavigationOptions = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/Components/FriendsLandingScreen/NavigationOptions")
local EnumScreens = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/EnumScreens")

local function getTransitionConfig()
	if UserGameSettings.ReducedMotion then
		return roactNavigation.StackViewTransitionConfigs.FadeInPlace
	end

	return roactNavigation.StackViewTransitionConfigs.SlideFromRight
end

return (roactNavigation.createRobloxStackNavigator({
	{
		[EnumScreens.FriendsLanding] = { screen = FriendsLandingScreen, navigationOptions = NavigationOptions }
	}
}, { transitionConfig = getTransitionConfig }))
