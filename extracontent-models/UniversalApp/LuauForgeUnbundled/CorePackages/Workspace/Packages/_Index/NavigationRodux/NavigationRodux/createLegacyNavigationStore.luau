local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/NavigationRodux/Cryo")
local tutils = require("@game/CorePackages/Workspace/Packages/_Workspace/NavigationRodux/tutils")
local Navigation = require("@game/CorePackages/Workspace/Packages/_Workspace/NavigationRodux/Navigation")
local getCurrentRouteState = Navigation.getCurrentRouteState
local getCurrentNavigationState = Navigation.getCurrentNavigationState
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/NavigationRodux/Signals")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/NavigationRodux/SharedFlags")
local fFlagAppIaHomeSubTab = SharedFlags.FFlagAppIaHomeSubTab
local fFlagSignalsNavProjected = SharedFlags.FFlagSignalsNavProjected
local fFlagSignalsNavP3Final = SharedFlags.FFlagSignalsNavP3Final
local fFlagSignalsNavP2NavigationPrimitives = SharedFlags.FFlagSignalsNavP2NavigationPrimitives

local Constants = require("@game/CorePackages/Workspace/Packages/_Index/NavigationRodux/NavigationRodux/Constants")
require("@game/CorePackages/Workspace/Packages/_Index/NavigationRodux/NavigationRodux/types")

local Utils = require("@game/CorePackages/Workspace/Packages/_Index/NavigationRodux/NavigationRodux/Utils")
local getLegacyPageFromRoactNavigationRoute = Utils.getLegacyPageFromRoactNavigationRoute
local getLegacyRouteFromRoactNavigationState = Utils.getLegacyRouteFromRoactNavigationState

local function legacyPageEqual(p2, p3)
	return tutils.shallowEqual(p2, p3)
end

local function legacyRouteEqual(list, list2): boolean
	if list == list2 then
		return true
	end

	if list == nil or list2 == nil or #list ~= #list2 then
		return false
	end

	for i = 1, #list do
		local item = list[i]
		local item2 = list2[i]

		if not tutils.shallowEqual(item, item2) then
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

local function createLegacyNavigationStore(p2)
	local createComputed = Signals.createComputed
	local function fn(p3)
		local state = p2.getState(p3)
		local result = {}

		for i = 1, state.index do
			local v5 = state.routes[i]

			if v5.routes and v5.routeName == Constants.TempRnSwitchNavigatorName then
				v5 = v5.routes[v5.index]
			end

			if fFlagAppIaHomeSubTab and v5.routes and v5.routeName == Constants.HomeContainerName then
				v5 = v5.routes[v5.index]
			end

			local legacyPageFromRoactNavigationRoute = getLegacyPageFromRoactNavigationRoute(v5)
			table.insert(
				result,
				Cryo.List.join(result[i - 1] or {}, { legacyPageFromRoactNavigationRoute })
			)
		end

		return result
	end

	local v5 = if fFlagSignalsNavP3Final then legacyHistoryEqual else nil
	local computed = createComputed(fn, v5)

	local createComputed2 = Signals.createComputed
	local function fn2(p3)
		return getLegacyRouteFromRoactNavigationState((p2.getState(p3)))
	end

	local v6 = if fFlagSignalsNavP3Final then legacyRouteEqual else nil
	local computed2 = createComputed2(fn2, v6)

	local createComputed3 = Signals.createComputed
	local function fn3(p3)
		if fFlagSignalsNavProjected then
			return getCurrentNavigationState((p2.getState(p3)))
		end

		return getCurrentRouteState((p2.getNavigation(p3)))
	end

	local v7 = if fFlagSignalsNavP3Final then routeStateEqual else nil
	local computed3 = createComputed3(fn3, v7)

	local createComputed4 = Signals.createComputed
	local function fn4(p3)
		local v8 = computed(p3)
		return v8[#v8]
	end

	local v8 = if fFlagSignalsNavP3Final then legacyRouteEqual else nil
	local computed4 = createComputed4(fn4, v8)

	local createComputed5 = Signals.createComputed
	local function fn5(p3)
		local v9 = computed(p3)
		local v10 = v9[#v9]
		return v10[#v10]
	end

	local v9 = if fFlagSignalsNavP3Final then legacyPageEqual else nil
	local computed5 = createComputed5(fn5, v9)
	local v10

	if fFlagSignalsNavP2NavigationPrimitives then
		v10 = Signals.createComputed(function(p3)
			local v11 = computed(p3)
			local v12 = v11[#v11]
			return v12[#v12].name
		end)
	else
		v10 = nil
	end

	local computeds = {}
	local function getIsCurrentPageSignal(p3)
		local v11 = computeds[p3]

		if v11 then
			return v11
		end

		local computed6 = Signals.createComputed(function(p4): boolean
			return v10(p4) == p3
		end)

		computeds[p3] = computed6
		return computed6
	end

	local computeds2 = {}
	local function getRouteContainsPageSignal(p3)
		local v11 = computeds2[p3]

		if v11 then
			return v11
		end

		local computed6 = Signals.createComputed(function(p4): boolean
			local v12 = computed2(p4)

			if v12 then
				for k, v13 in v12 do
					if v13.name == p3 then
						return true
					end
				end
			end

			return false
		end)

		computeds2[p3] = computed6
		return computed6
	end

	local v11

	if fFlagSignalsNavP2NavigationPrimitives then
		v11 = Signals.createComputed(function(p3)
			local v12 = computed(p3)
			return v12[#v12][1].name
		end)
	end

	local v12

	if fFlagSignalsNavP2NavigationPrimitives then
		v12 = Signals.createComputed(function(p3): boolean
			local v13 = computed(p3)
			return #v13[#v13] > 1
		end)
	end

	local v13

	if fFlagSignalsNavP2NavigationPrimitives then
		v13 = Signals.createComputed(function(p3)
			local v14 = computed(p3)
			return #v14[#v14]
		end)
	end

	local v14

	if fFlagSignalsNavP2NavigationPrimitives then
		v14 = Signals.createComputed(function(p3)
			return computed3(p3).key or ""
		end)
	end

	return {
		getHistory = computed,
		getCurrentRoute = computed3,
		getCurrentLegacyRoute = computed4,
		getCurrentPage = computed5,
		getCurrentPageName = v10,
		getIsCurrentPageSignal = getIsCurrentPageSignal,
		getRouteContainsPageSignal = getRouteContainsPageSignal,
		getCurrentTabName = v11,
		getCanGoBack = v12,
		getRouteDepth = v13,
		getCurrentRouteKey = v14
	}
end

return createLegacyNavigationStore
