local Parent = script:FindFirstAncestor("NavigationRodux").Parent
local FFlagAppIaHomeSubTab = require(Parent.SharedFlags).FFlagAppIaHomeSubTab

return {
	TempRnSwitchNavigatorName = "RootSwitchNavigator",
	HomeContainerName = if not FFlagAppIaHomeSubTab then nil else "HomeContainer"
}
