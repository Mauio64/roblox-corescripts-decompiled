local parent = script.Parent.Parent.Parent

require(parent.Navigation)
local NavigationRodux = require(parent.NavigationRodux)

local SharedFlags = require(parent.SharedFlags)
local FFlagAppIaHomeSubTab = SharedFlags.FFlagAppIaHomeSubTab

local set = { [NavigationRodux.Constants.TempRnSwitchNavigatorName] = true }

if FFlagAppIaHomeSubTab then
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
