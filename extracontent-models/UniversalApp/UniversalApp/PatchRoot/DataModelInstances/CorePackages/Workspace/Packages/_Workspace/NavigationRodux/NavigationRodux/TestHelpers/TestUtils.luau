local NavigationRodux = script:FindFirstAncestor("NavigationRodux")
local NavigationRoduxParent = NavigationRodux.Parent
local Navigation = require(NavigationRoduxParent.Navigation)
local getCurrentRouteState = Navigation.getCurrentRouteState
local RoactNavigation = require(NavigationRoduxParent.RoactNavigation)
local Actions = RoactNavigation.Actions
local StackActions = RoactNavigation.StackActions
local AppPage = require(NavigationRoduxParent.RobloxAppEnums).AppPage
local Constants = require(NavigationRodux.Constants)

require(NavigationRodux.types)

local getLegacyRouteFromRoactNavigationState = require(NavigationRodux.Utils).getLegacyRouteFromRoactNavigationState
local createMockStackState = Navigation.TestUtils.createMockStackState
local createMockScreenState = Navigation.TestUtils.createMockScreenState

local function createMockReducerStateFromRouteState(p1) -- line: 28
	-- upvalues: getLegacyRouteFromRoactNavigationState (copy), getCurrentRouteState (copy)
	local v18 = getLegacyRouteFromRoactNavigationState(p1)

	return {
		lockNavigationActions = false,
		backNavigationDisableCounter = 0,
		history = { v18 },
		currentRoute = getCurrentRouteState({
			state = p1
		}),
		roactNavigationState = p1
	}
end
local function createMockRouteStateFromPages(t1: {[any]: any}) -- line: 41
	-- upvalues: createMockScreenState (copy), createMockStackState (copy)
	local t2 = {}

	for _, v22 in t1 do
		table.insert(t2, createMockScreenState(v22.name, v22))
	end

	return createMockStackState("StackRouterRoot", t2)
end

local t3 = {
	[AppPage.Home] = true,
	[AppPage.Games] = true,
	[AppPage.Moments] = true,
	[AppPage.AvatarExperienceRoot] = true,
	[AppPage.Chat] = true,
	[AppPage.More] = true
}

local function navigateToRoute(p2, t4: {[any]: any}) -- line: 67
	-- upvalues: Actions (copy), t3 (copy), Constants (copy), StackActions (copy)
	local t5 = {}

	for _, v31 in t4 do
		local v32 = if typeof(v31) ~= "string" then v31 else {
			routeName = v31
		}
		local v33 = Actions.navigate(v32)

		if t3[v32.routeName] then
			v33 = Actions.navigate({
				routeName = Constants.TempRnSwitchNavigatorName,
				action = v33,
				key = Constants.TempRnSwitchNavigatorName
			})
		end

		table.insert(t5, v33)
	end

	p2.dispatch(StackActions.reset({
		index = #t5,
		actions = t5
	}))
end

return {
	createMockReducerStateFromRouteState = createMockReducerStateFromRouteState,
	createMockRouteStateFromPages = createMockRouteStateFromPages,
	createMockNavigationState = function(...) -- line: 49
		-- upvalues: createMockRouteStateFromPages (copy), createMockReducerStateFromRouteState (copy)
		local t6 = {}

		for _, v25 in { ... } do
			table.insert(t6, {
				name = v25
			})
		end

		local v26 = createMockRouteStateFromPages(t6)

		return (createMockReducerStateFromRouteState(v26))
	end,
	resetNavigation = function(p3, t7: {[any]: any}?) -- line: 87
		-- upvalues: navigateToRoute (copy)
		p3.notifyEvents()

		if t7 == nil or #t7 == 0 then
			p3.dispatch({
				type = "RESET_NAVIGATION_FOR_TESTING_ONLY__DO_NOT_USE_IN_PRODUCTION"
			})

			return
		end

		navigateToRoute(p3, t7)
		p3.notifyEvents()
	end,
	createMockStackState = createMockStackState,
	createMockSwitchState = Navigation.TestUtils.createMockSwitchState,
	createMockScreenState = createMockScreenState
}
