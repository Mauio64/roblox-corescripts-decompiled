local NavigationRodux = script:FindFirstAncestor("NavigationRodux")
local NavigationRoduxParent = NavigationRodux.Parent
local Cryo = require(NavigationRoduxParent.Cryo)
local getCurrentRouteState = require(NavigationRoduxParent.Navigation).getCurrentRouteState
local Signals = require(NavigationRoduxParent.Signals)
local FFlagAppIaHomeSubTab = require(NavigationRoduxParent.SharedFlags).FFlagAppIaHomeSubTab
local Constants = require(NavigationRodux.Constants)

require(NavigationRodux.types)

local getLegacyPageFromRoactNavigationRoute = require(script.Parent.Utils).getLegacyPageFromRoactNavigationRoute

local function createLegacyNavigationStore(p1) -- line: 28
	-- upvalues: Signals (copy), Constants (copy), FFlagAppIaHomeSubTab (copy), getLegacyPageFromRoactNavigationRoute (copy), Cryo (copy), getCurrentRouteState (copy)
	local v11 = Signals.createComputed(function(p2) -- line: 29
		-- upvalues: p1 (copy), Constants (copy), FFlagAppIaHomeSubTab (copy), getLegacyPageFromRoactNavigationRoute (copy), Cryo (copy)
		local t1 = {}
		local v17 = p1.getState(p2)

		for i = 1, v17.index do
			local v19 = v17.routes[i]

			if v19.routes and v19.routeName == Constants.TempRnSwitchNavigatorName then
				v19 = v19.routes[v19.index]
			end

			if FFlagAppIaHomeSubTab and v19.routes and v19.routeName == Constants.HomeContainerName then
				v19 = v19.routes[v19.index]
			end

			local v20 = getLegacyPageFromRoactNavigationRoute(v19)

			table.insert(t1, Cryo.List.join(t1[i - 1] or {}, { v20 }))
		end

		return t1
	end)
	local v12 = Signals.createComputed(function(p3) -- line: 51
		-- upvalues: p1 (copy), getCurrentRouteState (copy)
		local v22 = p1.getNavigation(p3)

		return (getCurrentRouteState(v22))
	end)
	local v13 = Signals.createComputed(function(p4) -- line: 56
		-- upvalues: v11 (copy)
		local v24 = v11(p4)

		return v24[#v24]
	end)
	local v14 = Signals.createComputed(function(p5) -- line: 61
		-- upvalues: v11 (copy)
		local v26 = v11(p5)
		local v27 = v26[#v26]

		return v27[#v27]
	end)

	return {
		getHistory = v11,
		getCurrentRoute = v12,
		getCurrentLegacyRoute = v13,
		getCurrentPage = v14
	}
end

return createLegacyNavigationStore
