local parent = script:FindFirstAncestor("NavigationRodux").Parent

local SharedFlags = require(parent.SharedFlags)
return {
	TempRnSwitchNavigatorName = "RootSwitchNavigator",
	HomeContainerName = SharedFlags.FFlagAppIaHomeSubTab and "HomeContainer" or nil
}
