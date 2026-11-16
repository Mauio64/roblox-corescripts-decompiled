local NavigationRodux = script:FindFirstAncestor("NavigationRodux")
local parent = NavigationRodux.Parent

local Cryo = require(parent.Cryo)
local tutils = require(parent.tutils)
local Navigation = require(parent.Navigation)
local getCurrentRouteState = Navigation.getCurrentRouteState
local getCurrentNavigationState = Navigation.getCurrentNavigationState
local Signals = require(parent.Signals)

local SharedFlags = require(parent.SharedFlags)
local FFlagAppIaHomeSubTab = SharedFlags.FFlagAppIaHomeSubTab
local FFlagSignalsNavProjected = SharedFlags.FFlagSignalsNavProjected
local FFlagSignalsNavP3Final = SharedFlags.FFlagSignalsNavP3Final
local FFlagSignalsNavP2NavigationPrimitives = SharedFlags.FFlagSignalsNavP2NavigationPrimitives

local Constants = require(NavigationRodux.Constants)
require(NavigationRodux.types)

local Utils = require(script.Parent.Utils)
local getLegacyPageFromRoactNavigationRoute = Utils.getLegacyPageFromRoactNavigationRoute
local getLegacyRouteFromRoactNavigationState = Utils.getLegacyRouteFromRoactNavigationState

local function legacyPageEqual(p, p2) -- 1 equivalent call inferred from this helper
	return tutils.shallowEqual(p, p2)
end

local function legacyRouteEqual(list, list2): boolean
	if list == list2 then
		return true
	end

	if list == nil or list2 == nil or #list ~= #list2 then
		return false
	end

	for i = 1, #list do
		if not legacyPageEqual(list[i], list2[i]) then -- inferred equivalent call
			return false
		end
	end

	return true
end

local function legacyHistoryEqual(list, list2): boolean
	if list == list2 then
		return true
	end

	if list == nil or list2 == nil or #list ~= #list2 then
		return false
	end

	for i = 1, #list do
		if not legacyRouteEqual(list[i], list2[i]) then
			return false
		end
	end

	return true
end

local function routeStateEqual(data, data2)
	if data == data2 then
		return true
	end

	if type(data) ~= "table" or type(data2) ~= "table" then
		return false
	end

	return data.routeName == data2.routeName
		and data.key == data2.key
		and tutils.shallowEqual(data.params or {}, data2.params or {})
end

local function createLegacyNavigationStore(p)
	local createComputed = Signals.createComputed
	local function fn(p2)
		local state = p.getState(p2)
		local result = {}

		for i = 1, state.index do
			local v = state.routes[i]

			if v.routes and v.routeName == Constants.TempRnSwitchNavigatorName then
				v = v.routes[v.index]
			end

			if FFlagAppIaHomeSubTab and v.routes and v.routeName == Constants.HomeContainerName then
				v = v.routes[v.index]
			end

			local legacyPageFromRoactNavigationRoute = getLegacyPageFromRoactNavigationRoute(v)
			table.insert(result, Cryo.List.join(result[i - 1] or {}, { legacyPageFromRoactNavigationRoute }))
		end

		return result
	end

	local v

	if FFlagSignalsNavP3Final then
		v = legacyHistoryEqual
	end

	local getHistory = createComputed(fn, v)

	local createComputed2 = Signals.createComputed
	local function fn2(p2)
		return getLegacyRouteFromRoactNavigationState((p.getState(p2)))
	end

	local v2

	if FFlagSignalsNavP3Final then
		v2 = legacyRouteEqual
	end

	local computed = createComputed2(fn2, v2)

	local createComputed3 = Signals.createComputed
	local function fn3(p2)
		if FFlagSignalsNavProjected then
			return (getCurrentNavigationState((p.getState(p2))))
		end

		return (getCurrentRouteState((p.getNavigation(p2))))
	end

	local v3

	if FFlagSignalsNavP3Final then
		v3 = routeStateEqual
	end

	local getCurrentRoute = createComputed3(fn3, v3)

	local createComputed4 = Signals.createComputed
	local function fn4(p2)
		local v4 = getHistory(p2)
		return v4[#v4]
	end

	local v4

	if FFlagSignalsNavP3Final then
		v4 = legacyRouteEqual
	end

	local getCurrentLegacyRoute = createComputed4(fn4, v4)

	local createComputed5 = Signals.createComputed
	local function fn5(p2)
		local v5 = getHistory(p2)
		local v6 = v5[#v5]
		return v6[#v6]
	end

	local v5

	if FFlagSignalsNavP3Final then
		v5 = legacyPageEqual
	end

	local getCurrentPage = createComputed5(fn5, v5)
	local getCurrentPageName

	if FFlagSignalsNavP2NavigationPrimitives then
		getCurrentPageName = Signals.createComputed(function(p2)
			local v6 = getHistory(p2)
			local v7 = v6[#v6]
			return v7[#v7].name
		end)
	else
		getCurrentPageName = nil
	end

	local computeds = {}
	local function getIsCurrentPageSignal(p2: string)
		local v6 = computeds[p2]

		if v6 then
			return v6
		end

		local computed2 = Signals.createComputed(function(p3): boolean
			return getCurrentPageName(p3) == p2
		end)

		computeds[p2] = computed2
		return computed2
	end

	local computeds2 = {}
	local function getRouteContainsPageSignal(p2: string)
		local v6 = computeds2[p2]

		if v6 then
			return v6
		end

		local computed2 = Signals.createComputed(function(p3): boolean
			local v7 = computed(p3)

			if v7 then
				for _, v8 in v7 do
					if v8.name == p2 then
						return true
					end
				end
			end

			return false
		end)

		computeds2[p2] = computed2
		return computed2
	end

	local getCurrentTabName

	if FFlagSignalsNavP2NavigationPrimitives then
		getCurrentTabName = Signals.createComputed(function(p2)
			local v6 = getHistory(p2)
			return v6[#v6][1].name
		end)
	end

	local getCanGoBack

	if FFlagSignalsNavP2NavigationPrimitives then
		getCanGoBack = Signals.createComputed(function(p2): boolean
			local v6 = getHistory(p2)
			return #v6[#v6] > 1
		end)
	end

	local getRouteDepth

	if FFlagSignalsNavP2NavigationPrimitives then
		getRouteDepth = Signals.createComputed(function(p2)
			local v6 = getHistory(p2)
			return #v6[#v6]
		end)
	end

	local getCurrentRouteKey

	if FFlagSignalsNavP2NavigationPrimitives then
		getCurrentRouteKey = Signals.createComputed(function(p2)
			return getCurrentRoute(p2).key or ""
		end)
	end

	return {
		getHistory = getHistory,
		getCurrentRoute = getCurrentRoute,
		getCurrentLegacyRoute = getCurrentLegacyRoute,
		getCurrentPage = getCurrentPage,
		getCurrentPageName = getCurrentPageName,
		getIsCurrentPageSignal = getIsCurrentPageSignal,
		getRouteContainsPageSignal = getRouteContainsPageSignal,
		getCurrentTabName = getCurrentTabName,
		getCanGoBack = getCanGoBack,
		getRouteDepth = getRouteDepth,
		getCurrentRouteKey = getCurrentRouteKey
	}
end

return createLegacyNavigationStore
