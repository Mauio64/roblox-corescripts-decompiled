local Navigation = require("@game/CorePackages/Workspace/Packages/_Workspace/NavigationRodux/Navigation")
local getCurrentRouteState = Navigation.getCurrentRouteState
local RoactNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/NavigationRodux/RoactNavigation")
local actions = RoactNavigation.Actions
local stackActions = RoactNavigation.StackActions
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/NavigationRodux/RobloxAppEnums").AppPage

local Constants = require("@game/CorePackages/Workspace/Packages/_Index/NavigationRodux/NavigationRodux/Constants")
require("@game/CorePackages/Workspace/Packages/_Index/NavigationRodux/NavigationRodux/types")
local getLegacyRouteFromRoactNavigationState = require("@game/CorePackages/Workspace/Packages/_Index/NavigationRodux/NavigationRodux/Utils").getLegacyRouteFromRoactNavigationState

local createMockStackState = Navigation.TestUtils.createMockStackState
local createMockScreenState = Navigation.TestUtils.createMockScreenState

local function createMockReducerStateFromRouteState(mockRouteStateFromPages)
	return {
		history = { (getLegacyRouteFromRoactNavigationState(mockRouteStateFromPages)) },
		currentRoute = getCurrentRouteState({ state = mockRouteStateFromPages }),
		roactNavigationState = mockRouteStateFromPages,
		lockNavigationActions = false,
		backNavigationDisableCounter = 0
	}
end

local function createMockRouteStateFromPages(items)
	local v5 = {}

	for k, item in items do
		table.insert(v5, createMockScreenState(item.name, item))
	end

	return createMockStackState("StackRouterRoot", v5)
end

local set = {
	[appPage.Home] = true,
	[appPage.Games] = true,
	[appPage.Moments] = true,
	[appPage.AvatarExperienceRoot] = true,
	[appPage.Chat] = true,
	[appPage.More] = true
}

local function navigateToRoute(p2, items)
	local v5 = {}

	for k, item in items do
		local v6 = typeof(item) == "string" and { routeName = item } or item
		local v7 = actions.navigate(v6)

		if set[v6.routeName] then
			v7 = actions.navigate({
				routeName = Constants.TempRnSwitchNavigatorName,
				action = v7,
				key = Constants.TempRnSwitchNavigatorName
			})
		end

		table.insert(v5, v7)
	end

	p2.dispatch(stackActions.reset({
		index = #v5,
		actions = v5
	}))
end

return {
	createMockReducerStateFromRouteState = createMockReducerStateFromRouteState,
	createMockRouteStateFromPages = createMockRouteStateFromPages,
	createMockNavigationState = function(...)
		local v5 = {}

		for k, v6 in { ... } do
			table.insert(v5, { name = v6 })
		end

		return createMockReducerStateFromRouteState(createMockRouteStateFromPages(v5))
	end,
	resetNavigation = function(p2, list)
		p2.notifyEvents()

		if list == nil or #list == 0 then
			p2.dispatch({
				type = "RESET_NAVIGATION_FOR_TESTING_ONLY__DO_NOT_USE_IN_PRODUCTION"
			})
			return
		end

		navigateToRoute(p2, list)
		p2.notifyEvents()
	end,
	createMockStackState = createMockStackState,
	createMockSwitchState = Navigation.TestUtils.createMockSwitchState,
	createMockScreenState = createMockScreenState
}
