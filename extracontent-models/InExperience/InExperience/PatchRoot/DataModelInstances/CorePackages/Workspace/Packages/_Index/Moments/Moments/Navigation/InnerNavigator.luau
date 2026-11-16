local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local RoactNavigation = require(parent.RoactNavigation)

local Routes = require(Moments.Navigation.Routes)
local TrendingScreen = require(Moments.Components.TrendingScreen)
local MomentsFeed = Routes.MomentsFeed

return (RoactNavigation.createRobloxSwitchNavigator({
	{
		[MomentsFeed] = { screen = TrendingScreen }
	}
}, {
	initialRouteName = MomentsFeed,
	keepVisitedScreensMounted = true,
	backBehavior = RoactNavigation.BackBehavior.History
}))
