local Moments = script:FindFirstAncestor("Moments")
local MomentsParent = Moments.Parent
local RoactNavigation = require(MomentsParent.RoactNavigation)
local SharedFlags = require(MomentsParent.SharedFlags)
local Routes = require(Moments.Navigation.Routes)
local TrendingScreen = require(Moments.Components.TrendingScreen)
local v7 = if not SharedFlags.FFlagMomentsWatchSessionalization then Routes.TrendingScreen else Routes.MomentsFeed

return (RoactNavigation.createRobloxSwitchNavigator({{
	[v7] = {
		screen = TrendingScreen
	}
}}, {
	keepVisitedScreensMounted = true,
	initialRouteName = v7,
	backBehavior = RoactNavigation.BackBehavior.History
}))
