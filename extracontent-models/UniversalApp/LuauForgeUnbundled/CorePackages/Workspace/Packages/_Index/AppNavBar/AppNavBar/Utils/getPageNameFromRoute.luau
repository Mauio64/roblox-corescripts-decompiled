require("@game/CorePackages/Workspace/Packages/_Workspace/AppNavBar/Navigation")
local NavigationRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/AppNavBar/NavigationRodux")

local fFlagAppIaHomeSubTab = require("@game/CorePackages/Workspace/Packages/_Workspace/AppNavBar/SharedFlags").FFlagAppIaHomeSubTab

local set = { [NavigationRodux.Constants.TempRnSwitchNavigatorName] = true }

if fFlagAppIaHomeSubTab then
	set[NavigationRodux.Constants.HomeContainerName] = true
end

return function(data)
	if not data then
		return nil
	end

	while set[data.routeName] and data.routes and data.index do
		data = data.routes[data.index]
	end

	return data.routeName
end
