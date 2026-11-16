local RoactNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/RoactNavigation")

local Routes = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Navigation/Routes")
local TrendingScreen = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/TrendingScreen")
local momentsFeed = Routes.MomentsFeed

return (RoactNavigation.createRobloxSwitchNavigator({
	{
		[momentsFeed] = { screen = TrendingScreen }
	}
}, {
	initialRouteName = momentsFeed,
	keepVisitedScreensMounted = true,
	backBehavior = RoactNavigation.BackBehavior.History
}))
