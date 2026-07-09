local ParentParent = script.Parent.Parent.Parent

require(ParentParent.Navigation)

local NavigationRodux = require(ParentParent.NavigationRodux)
local FFlagAppIaHomeSubTab = require(ParentParent.SharedFlags).FFlagAppIaHomeSubTab
local t1 = {
	[NavigationRodux.Constants.TempRnSwitchNavigatorName] = true
}

if FFlagAppIaHomeSubTab then
	t1[NavigationRodux.Constants.HomeContainerName] = true
end

return function(p1) -- line: 20
	-- upvalues: t1 (copy)
	if not p1 then
		return nil
	end

	while t1[p1.routeName] and p1.routes and p1.index do
		p1 = p1.routes[p1.index]
	end

	return p1.routeName
end
