local NavigationRodux = script:FindFirstAncestor("NavigationRodux")
local parent = NavigationRodux.Parent

local Navigation = require(parent.Navigation)
local getCurrentRouteState = Navigation.getCurrentRouteState
local RoactNavigation = require(parent.RoactNavigation)
local Actions = RoactNavigation.Actions
local StackActions = RoactNavigation.StackActions
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage

local Constants = require(NavigationRodux.Constants)
require(NavigationRodux.types)
local Utils = require(NavigationRodux.Utils)
local getLegacyRouteFromRoactNavigationState = Utils.getLegacyRouteFromRoactNavigationState

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
	local v = {}

	for _, item in items do
		table.insert(v, createMockScreenState(item.name, item))
	end

	return createMockStackState("StackRouterRoot", v)
end

local set = {
	[AppPage.Home] = true,
	[AppPage.Games] = true,
	[AppPage.Moments] = true,
	[AppPage.AvatarExperienceRoot] = true,
	[AppPage.Chat] = true,
	[AppPage.More] = true
}

local function navigateToRoute(p, items)
	local actions = {}

	for _, item in items do
		local v = typeof(item) == "string" and { routeName = item } or item
		local action = Actions.navigate(v)

		if set[v.routeName] then
			action = Actions.navigate({
				routeName = Constants.TempRnSwitchNavigatorName,
				action = action,
				key = Constants.TempRnSwitchNavigatorName
			})
		end

		table.insert(actions, action)
	end

	p.dispatch(StackActions.reset({
		index = #actions,
		actions = actions
	}))
end

local TestUtils = {}
TestUtils.createMockReducerStateFromRouteState = createMockReducerStateFromRouteState
TestUtils.createMockRouteStateFromPages = createMockRouteStateFromPages

function TestUtils.createMockNavigationState(...)
	local v = {}

	for _, name in { ... } do
		table.insert(v, { name = name })
	end

	return createMockReducerStateFromRouteState(createMockRouteStateFromPages(v))
end

function TestUtils.resetNavigation(p, list)
	p.notifyEvents()

	if list == nil or #list == 0 then
		p.dispatch({ type = "RESET_NAVIGATION_FOR_TESTING_ONLY__DO_NOT_USE_IN_PRODUCTION" })
		return
	end

	navigateToRoute(p, list)
	p.notifyEvents()
end

TestUtils.createMockStackState = createMockStackState
TestUtils.createMockSwitchState = Navigation.TestUtils.createMockSwitchState
TestUtils.createMockScreenState = createMockScreenState
return TestUtils
