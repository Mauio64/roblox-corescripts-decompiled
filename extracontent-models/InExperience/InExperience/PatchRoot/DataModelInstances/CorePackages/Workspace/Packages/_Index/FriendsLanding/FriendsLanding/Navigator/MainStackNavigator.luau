local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local parent = FriendsLanding.Parent
local dependencies = require(FriendsLanding.dependencies)

local UserGameSettings = UserSettings():GetService("UserGameSettings")
local roactNavigation = dependencies.RoactNavigation
local FriendsLandingScreen = require(FriendsLanding.Components.FriendsLandingScreen)

local NavigationOptions = require(FriendsLanding.Components.FriendsLandingScreen.NavigationOptions)
local EnumScreens = require(FriendsLanding.EnumScreens)

local function getTransitionConfig()
	if UserGameSettings.ReducedMotion then
		return roactNavigation.StackViewTransitionConfigs.FadeInPlace
	end

	return roactNavigation.StackViewTransitionConfigs.SlideFromRight
end

return (roactNavigation.createRobloxStackNavigator({
	{
		[EnumScreens.FriendsLanding] = {
			screen = FriendsLandingScreen,
			navigationOptions = NavigationOptions
		}
	}
}, { transitionConfig = getTransitionConfig }))
