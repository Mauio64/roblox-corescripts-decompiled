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

local getLegacyPageFromRoactNavigationRoute = require(script.Parent.Utils).getLegacyPageFromRoactNavigationRoute

local function legacyPageEqual(p1, p2) -- line: 34
	-- upvalues: tutils (copy)
	return tutils.shallowEqual(p1, p2)
end
local function legacyRouteEqual(p3, p4) -- line: 38
	-- upvalues: tutils (copy)
	if p3 == p4 then
		return true
	end

	if p3 == nil or p4 == nil or #p3 ~= #p4 then
		return false
	end

	for i = 1, #p3 do
		local v26 = p3[i]
		local v27 = p4[i]

		if not tutils.shallowEqual(v26, v27) then
			return false
		end
	end

	return true
end
local function legacyHistoryEqual(p5, p6) -- line: 53
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
local function routeStateEqual(p7, p8) -- line: 68
	-- upvalues: tutils (copy)
	if p7 == p8 then
		return true
	end

	if type(p7) ~= "table" or type(p8) ~= "table" then
		return false
	end

	return p7.routeName == p8.routeName and (p7.key == p8.key and tutils.shallowEqual(p7.params or {}, p8.params or {}))
end
local function createLegacyNavigationStore(p9) -- line: 98
	-- upvalues: Signals (copy), Constants (copy), FFlagAppIaHomeSubTab (copy), getLegacyPageFromRoactNavigationRoute (copy), Cryo (copy), FFlagSignalsNavP3Final (copy), legacyHistoryEqual (copy), FFlagSignalsNavProjected (copy), getCurrentNavigationState (copy), getCurrentRouteState (copy), routeStateEqual (copy), legacyRouteEqual (copy), legacyPageEqual (copy), FFlagSignalsNavP2NavigationPrimitives (copy)
	local v34 = Signals.createComputed(function(p10) -- line: 99
		-- upvalues: p9 (copy), Constants (copy), FFlagAppIaHomeSubTab (copy), getLegacyPageFromRoactNavigationRoute (copy), Cryo (copy)
		local t1 = {}
		local v47 = p9.getState(p10)

		for i = 1, v47.index do
			local v49 = v47.routes[i]

			if v49.routes and v49.routeName == Constants.TempRnSwitchNavigatorName then
				v49 = v49.routes[v49.index]
			end

			if FFlagAppIaHomeSubTab and v49.routes and v49.routeName == Constants.HomeContainerName then
				v49 = v49.routes[v49.index]
			end

			local v50 = getLegacyPageFromRoactNavigationRoute(v49)

			table.insert(t1, Cryo.List.join(t1[i - 1] or {}, { v50 }))
		end

		return t1
	end, if not FFlagSignalsNavP3Final then nil else legacyHistoryEqual)
	local v35 = Signals.createComputed(function(p11) -- line: 121
		-- upvalues: FFlagSignalsNavProjected (copy), p9 (copy), getCurrentNavigationState (copy), getCurrentRouteState (copy)
		if FFlagSignalsNavProjected then
			local v52 = p9.getState(p11)

			return (getCurrentNavigationState(v52))
		end

		local v53 = p9.getNavigation(p11)

		return (getCurrentRouteState(v53))
	end, if not FFlagSignalsNavP3Final then nil else routeStateEqual)
	local v36 = Signals.createComputed(function(p12) -- line: 135
		-- upvalues: v34 (copy)
		local v55 = v34(p12)

		return v55[#v55]
	end, if not FFlagSignalsNavP3Final then nil else legacyRouteEqual)
	local v37 = Signals.createComputed(function(p13) -- line: 140
		-- upvalues: v34 (copy)
		local v57 = v34(p13)
		local v58 = v57[#v57]

		return v58[#v58]
	end, if not FFlagSignalsNavP3Final then nil else legacyPageEqual)
	local v38 = if not FFlagSignalsNavP2NavigationPrimitives then nil else Signals.createComputed(function(p14) -- line: 147
		-- upvalues: v34 (copy)
		local v60 = v34(p14)
		local v61 = v60[#v60]

		return v61[#v61].name
	end)
	local t2 = {}
	local t3 = {}
	local v41 = if not FFlagSignalsNavP2NavigationPrimitives then nil else Signals.createComputed(function(p15) -- line: 195
		-- upvalues: v34 (copy)
		local v69 = v34(p15)

		return v69[#v69][1].name
	end)
	local v42 = if not FFlagSignalsNavP2NavigationPrimitives then nil else Signals.createComputed(function(p16) -- line: 203
		-- upvalues: v34 (copy)
		local v71 = v34(p16)

		return #v71[#v71] > 1
	end)
	local v43 = if not FFlagSignalsNavP2NavigationPrimitives then nil else Signals.createComputed(function(p17) -- line: 211
		-- upvalues: v34 (copy)
		local v73 = v34(p17)

		return #v73[#v73]
	end)
	local v44 = if not FFlagSignalsNavP2NavigationPrimitives then nil else Signals.createComputed(function(p18) -- line: 219
		-- upvalues: v35 (copy)
		return v35(p18).key or ""
	end)

	return {
		getHistory = v34,
		getCurrentRoute = v35,
		getCurrentLegacyRoute = v36,
		getCurrentPage = v37,
		getCurrentPageName = v38,
		getIsCurrentPageSignal = function(s1: string) -- line: 158
			-- upvalues: t2 (copy), Signals (copy), v38 (copy)
			local v63 = t2[s1]

			if v63 then
				return v63
			end

			local v64 = Signals.createComputed(function(p19) -- line: 163
				-- upvalues: v38 (copy), s1 (copy)
				return v38(p19) == s1
			end)

			t2[s1] = v64

			return v64
		end,
		getRouteContainsPageSignal = function(s2: string) -- line: 173
			-- upvalues: t3 (copy), Signals (copy), v34 (copy)
			local v66 = t3[s2]

			if v66 then
				return v66
			end

			local v67 = Signals.createComputed(function(p20) -- line: 178
				-- upvalues: v34 (copy), s2 (copy)
				local v77 = v34(p20)
				local v78 = v77[#v77]

				if v78 then
					for _, v80 in v78 do
						if v80.name == s2 then
							return true
						end
					end
				end

				return false
			end)

			t3[s2] = v67

			return v67
		end,
		getCurrentTabName = v41,
		getCanGoBack = v42,
		getRouteDepth = v43,
		getCurrentRouteKey = v44
	}
end

return createLegacyNavigationStore
