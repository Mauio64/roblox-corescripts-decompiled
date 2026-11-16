local NavigationRodux = script:FindFirstAncestor("NavigationRodux")
local parent = NavigationRodux.Parent

local Cryo = require(parent.Cryo)
local Navigation = require(parent.Navigation)
local getActiveRoutes = Navigation.getActiveRoutes
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage

require(NavigationRodux.types)
local Constants = require(NavigationRodux.Constants)

local function legacyRouteFilter(p): boolean
	return p.routeName ~= Constants.TempRnSwitchNavigatorName and p.key ~= "StackRouterRoot"
end

local function getLegacyPageFromRoactNavigationRoute(data)
	return Cryo.Dictionary.join(data.params or {}, { name = data.routeName, rnKey = data.key })
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

local Utils = {}
Utils.getLegacyPageFromRoactNavigationRoute = getLegacyPageFromRoactNavigationRoute

function Utils.getLegacyRouteFromRoactNavigationState(p)
	return Cryo.List.map(Cryo.List.filter(getActiveRoutes(p), legacyRouteFilter), getLegacyPageFromRoactNavigationRoute)
end

function Utils.getCurrentTabName(data)
	if data.routeName ~= Constants.TempRnSwitchNavigatorName then
		local route = data.routes[data.index]

		if route.routes then
			data = getTabNavigatorState(route)
		else
			data = nil
		end
	end

	if data == nil then
		return AppPage.None
	end

	return data.routes[data.index].routeName
end

return Utils
