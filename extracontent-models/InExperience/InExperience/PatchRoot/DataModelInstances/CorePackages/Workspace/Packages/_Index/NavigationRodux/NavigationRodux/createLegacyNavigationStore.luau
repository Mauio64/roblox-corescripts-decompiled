local NavigationRodux = script:FindFirstAncestor("NavigationRodux")
local NavigationRoduxParent = NavigationRodux.Parent
local Cryo = require(NavigationRoduxParent.Cryo)
local tutils = require(NavigationRoduxParent.tutils)
local Navigation = require(NavigationRoduxParent.Navigation)
local getCurrentRouteState = Navigation.getCurrentRouteState
local getCurrentNavigationState = Navigation.getCurrentNavigationState
local Signals = require(NavigationRoduxParent.Signals)
local SharedFlags = require(NavigationRoduxParent.SharedFlags)
local FFlagAppIaHomeSubTab = SharedFlags.FFlagAppIaHomeSubTab
local FFlagSignalsNavProjected = SharedFlags.FFlagSignalsNavProjected
local FFlagSignalsNavP3Final = SharedFlags.FFlagSignalsNavP3Final
local FFlagSignalsNavP2NavigationPrimitives = SharedFlags.FFlagSignalsNavP2NavigationPrimitives
local Constants = require(NavigationRodux.Constants)

require(NavigationRodux.types)

local Utils = require(script.Parent.Utils)
local getLegacyPageFromRoactNavigationRoute = Utils.getLegacyPageFromRoactNavigationRoute
local getLegacyRouteFromRoactNavigationState = Utils.getLegacyRouteFromRoactNavigationState

local function legacyPageEqual(p1, p2) -- line: 36
	-- upvalues: tutils (copy)
	return tutils.shallowEqual(p1, p2)
end
local function legacyRouteEqual(p3, p4) -- line: 40
	-- upvalues: tutils (copy)
	if p3 == p4 then
		return true
	end

	if p3 == nil or p4 == nil or #p3 ~= #p4 then
		return false
	end

	for i = 1, #p3 do
		local v28 = p3[i]
		local v29 = p4[i]

		if not tutils.shallowEqual(v28, v29) then
			return false
		end
	end

	return true
end
local function legacyHistoryEqual(p5, p6) -- line: 55
	-- upvalues: legacyRouteEqual (copy)
	if p5 == p6 then
		return true
	end

	if p5 == nil or p6 == nil or #p5 ~= #p6 then
		return false
	end

	for i = 1, #p5 do
		if not legacyRouteEqual(p5[i], p6[i]) then
			return false
		end
	end

	return true
end
local function routeStateEqual(p7, p8) -- line: 70
	-- upvalues: tutils (copy)
	if p7 == p8 then
		return true
	end

	if type(p7) ~= "table" or type(p8) ~= "table" then
		return false
	end

	return p7.routeName == p8.routeName and (p7.key == p8.key and tutils.shallowEqual(p7.params or {}, p8.params or {}))
end
local function createLegacyNavigationStore(p9) -- line: 100
	-- upvalues: Signals (copy), Constants (copy), FFlagAppIaHomeSubTab (copy), getLegacyPageFromRoactNavigationRoute (copy), Cryo (copy), FFlagSignalsNavP3Final (copy), legacyHistoryEqual (copy), getLegacyRouteFromRoactNavigationState (copy), legacyRouteEqual (copy), FFlagSignalsNavProjected (copy), getCurrentNavigationState (copy), getCurrentRouteState (copy), routeStateEqual (copy), legacyPageEqual (copy), FFlagSignalsNavP2NavigationPrimitives (copy)
	local v36 = Signals.createComputed(function(p10) -- line: 106
		-- upvalues: p9 (copy), Constants (copy), FFlagAppIaHomeSubTab (copy), getLegacyPageFromRoactNavigationRoute (copy), Cryo (copy)
		local t1 = {}
		local v50 = p9.getState(p10)

		for i = 1, v50.index do
			local v52 = v50.routes[i]

			if v52.routes and v52.routeName == Constants.TempRnSwitchNavigatorName then
				v52 = v52.routes[v52.index]
			end

			if FFlagAppIaHomeSubTab and v52.routes and v52.routeName == Constants.HomeContainerName then
				v52 = v52.routes[v52.index]
			end

			local v53 = getLegacyPageFromRoactNavigationRoute(v52)

			table.insert(t1, Cryo.List.join(t1[i - 1] or {}, { v53 }))
		end

		return t1
	end, if not FFlagSignalsNavP3Final then nil else legacyHistoryEqual)
	local v37 = Signals.createComputed(function(p11) -- line: 132
		-- upvalues: p9 (copy), getLegacyRouteFromRoactNavigationState (copy)
		local v55 = p9.getState(p11)

		return getLegacyRouteFromRoactNavigationState(v55)
	end, if not FFlagSignalsNavP3Final then nil else legacyRouteEqual)
	local v38 = Signals.createComputed(function(p12) -- line: 137
		-- upvalues: FFlagSignalsNavProjected (copy), p9 (copy), getCurrentNavigationState (copy), getCurrentRouteState (copy)
		if FFlagSignalsNavProjected then
			local v57 = p9.getState(p12)

			return (getCurrentNavigationState(v57))
		end

		local v58 = p9.getNavigation(p12)

		return (getCurrentRouteState(v58))
	end, if not FFlagSignalsNavP3Final then nil else routeStateEqual)
	local v39 = Signals.createComputed(function(p13) -- line: 151
		-- upvalues: v36 (copy)
		local v60 = v36(p13)

		return v60[#v60]
	end, if not FFlagSignalsNavP3Final then nil else legacyRouteEqual)
	local v40 = Signals.createComputed(function(p14) -- line: 156
		-- upvalues: v36 (copy)
		local v62 = v36(p14)
		local v63 = v62[#v62]

		return v63[#v63]
	end, if not FFlagSignalsNavP3Final then nil else legacyPageEqual)
	local v41 = if not FFlagSignalsNavP2NavigationPrimitives then nil else Signals.createComputed(function(p15) -- line: 163
		-- upvalues: v36 (copy)
		local v65 = v36(p15)
		local v66 = v65[#v65]

		return v66[#v66].name
	end)
	local t2 = {}
	local t3 = {}
	local v44 = if not FFlagSignalsNavP2NavigationPrimitives then nil else Signals.createComputed(function(p16) -- line: 213
		-- upvalues: v36 (copy)
		local v74 = v36(p16)

		return v74[#v74][1].name
	end)
	local v45 = if not FFlagSignalsNavP2NavigationPrimitives then nil else Signals.createComputed(function(p17) -- line: 221
		-- upvalues: v36 (copy)
		local v76 = v36(p17)

		return #v76[#v76] > 1
	end)
	local v46 = if not FFlagSignalsNavP2NavigationPrimitives then nil else Signals.createComputed(function(p18) -- line: 229
		-- upvalues: v36 (copy)
		local v78 = v36(p18)

		return #v78[#v78]
	end)
	local v47 = if not FFlagSignalsNavP2NavigationPrimitives then nil else Signals.createComputed(function(p19) -- line: 237
		-- upvalues: v38 (copy)
		return v38(p19).key or ""
	end)

	return {
		getHistory = v36,
		getCurrentRoute = v38,
		getCurrentLegacyRoute = v39,
		getCurrentPage = v40,
		getCurrentPageName = v41,
		getIsCurrentPageSignal = function(s1: string) -- line: 174
			-- upvalues: t2 (copy), Signals (copy), v41 (copy)
			local v68 = t2[s1]

			if v68 then
				return v68
			end

			local v69 = Signals.createComputed(function(p20) -- line: 179
				-- upvalues: v41 (copy), s1 (copy)
				return v41(p20) == s1
			end)

			t2[s1] = v69

			return v69
		end,
		getRouteContainsPageSignal = function(s2: string) -- line: 192
			-- upvalues: t3 (copy), Signals (copy), v37 (copy)
			local v71 = t3[s2]

			if v71 then
				return v71
			end

			local v72 = Signals.createComputed(function(p21) -- line: 197
				-- upvalues: v37 (copy), s2 (copy)
				local v82 = v37(p21)

				if v82 then
					for _, v84 in v82 do
						if v84.name == s2 then
							return true
						end
					end
				end

				return false
			end)

			t3[s2] = v72

			return v72
		end,
		getCurrentTabName = v44,
		getCanGoBack = v45,
		getRouteDepth = v46,
		getCurrentRouteKey = v47
	}
end

return createLegacyNavigationStore
