local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/NavigationRodux/Cryo")
local getActiveRoutes = require("@game/CorePackages/Workspace/Packages/_Workspace/NavigationRodux/Navigation").getActiveRoutes
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/NavigationRodux/RobloxAppEnums").AppPage
local fFlagAppIaHomeSubTab = require("@game/CorePackages/Workspace/Packages/_Workspace/NavigationRodux/SharedFlags").FFlagAppIaHomeSubTab

require("@game/CorePackages/Workspace/Packages/_Index/NavigationRodux/NavigationRodux/types")
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/NavigationRodux/NavigationRodux/Constants")

local function legacyRouteFilter(p2): boolean
	return p2.routeName ~= Constants.TempRnSwitchNavigatorName and p2.key ~= "StackRouterRoot"
end

local function getLegacyPageFromRoactNavigationRoute(data)
	return Cryo.Dictionary.join(data.params or {}, {
		name = data.routeName,
		rnKey = data.key
	})
end

local function getTabNavigatorState(route)
	if route.routeName == Constants.TempRnSwitchNavigatorName then
		return route
	end

	local route2 = route.routes[route.index]

	if route2.routes then
		return getTabNavigatorState(route2)
	end

	return nil
end

return {
	getLegacyPageFromRoactNavigationRoute = getLegacyPageFromRoactNavigationRoute,
	getLegacyRouteFromRoactNavigationState = function(p2)
		return Cryo.List.map(
			Cryo.List.filter(getActiveRoutes(p2), legacyRouteFilter),
			getLegacyPageFromRoactNavigationRoute
		)
	end,
	getLegacyHistoryFromRoactNavigationState = function(p2)
		local legacyHistory = {}

		for i = 1, p2.index do
			local v5 = p2.routes[i]

			if v5.routes and v5.routeName == Constants.TempRnSwitchNavigatorName then
				v5 = v5.routes[v5.index]
			end

			if fFlagAppIaHomeSubTab and v5.routes and v5.routeName == Constants.HomeContainerName then
				v5 = v5.routes[v5.index]
			end

			local legacyPageFromRoactNavigationRoute = getLegacyPageFromRoactNavigationRoute(v5)
			legacyHistory[i] = Cryo.List.join(legacyHistory[i - 1] or {}, {
				legacyPageFromRoactNavigationRoute
			})
		end

		return legacyHistory
	end,
	getCurrentTabName = function(data)
		if data.routeName ~= Constants.TempRnSwitchNavigatorName then
			local route = data.routes[data.index]
			data = if route.routes then getTabNavigatorState(route) else nil
		end

		if data == nil then
			return appPage.None
		end

		return data.routes[data.index].routeName
	end
}
