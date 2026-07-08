local NavigationRodux = script:FindFirstAncestor("NavigationRodux")
local NavigationRoduxParent = NavigationRodux.Parent
local Cryo = require(NavigationRoduxParent.Cryo)
local getActiveRoutes = require(NavigationRoduxParent.Navigation).getActiveRoutes
local AppPage = require(NavigationRoduxParent.RobloxAppEnums).AppPage

require(NavigationRodux.types)

local Constants = require(NavigationRodux.Constants)

local function legacyRouteFilter(p1) -- line: 18
	-- upvalues: Constants (copy)
	return p1.routeName ~= Constants.TempRnSwitchNavigatorName and p1.key ~= "StackRouterRoot"
end
local function getLegacyPageFromRoactNavigationRoute(p2) -- line: 22
	-- upvalues: Cryo (copy)
	return Cryo.Dictionary.join(p2.params or {}, {
		name = p2.routeName,
		rnKey = p2.key
	})
end
local function getTabNavigatorState(p3) -- line: 36
	-- upvalues: Constants (copy), getTabNavigatorState (copy)
	if p3.routeName == Constants.TempRnSwitchNavigatorName then
		return p3
	end

	local v14 = p3.routes[p3.index]

	if v14.routes then
		return getTabNavigatorState(v14)
	end

	return nil
end

return {
	getLegacyPageFromRoactNavigationRoute = getLegacyPageFromRoactNavigationRoute,
	getLegacyRouteFromRoactNavigationState = function(p4) -- line: 29
		-- upvalues: Cryo (copy), getActiveRoutes (copy), legacyRouteFilter (copy), getLegacyPageFromRoactNavigationRoute (copy)
		return Cryo.List.map(Cryo.List.filter(getActiveRoutes(p4), legacyRouteFilter), getLegacyPageFromRoactNavigationRoute)
	end,
	getCurrentTabName = function(p5) -- line: 49
		-- upvalues: Constants (copy), getTabNavigatorState (copy), AppPage (copy)
		if p5.routeName == Constants.TempRnSwitchNavigatorName then
		else
			local v16 = p5.routes[p5.index]

			p5 = if not v16.routes then nil else getTabNavigatorState(v16)
		end

		if p5 ~= nil then
			return p5.routes[p5.index].routeName
		end

		return AppPage.None
	end
}
