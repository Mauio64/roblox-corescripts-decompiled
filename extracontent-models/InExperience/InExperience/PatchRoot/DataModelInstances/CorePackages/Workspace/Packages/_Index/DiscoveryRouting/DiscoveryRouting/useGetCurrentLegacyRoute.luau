local Parent = script:FindFirstAncestor("DiscoveryRouting").Parent
local React = require(Parent.React)
local useStore = require(Parent.RoactUtils).Hooks.RoactRodux.useStore
local NavigationRodux = require(Parent.NavigationRodux)
local selectCurrentLegacyRoute = NavigationRodux.Selectors.selectCurrentLegacyRoute
local GetLegacyNavigationStore = NavigationRodux.GetLegacyNavigationStore
local FFlagSignalsNavP2NavigationPrimitives = require(Parent.SharedFlags).FFlagSignalsNavP2NavigationPrimitives

local function getCurrentLegacyRouteFromSignals() -- line: 17
	-- upvalues: GetLegacyNavigationStore (copy)
	return GetLegacyNavigationStore(false).getCurrentLegacyRoute(false)
end
local function useGetCurrentLegacyRoute() -- line: 23
	-- upvalues: FFlagSignalsNavP2NavigationPrimitives (copy), getCurrentLegacyRouteFromSignals (copy), useStore (copy), React (copy), selectCurrentLegacyRoute (copy)
	if FFlagSignalsNavP2NavigationPrimitives then
		return getCurrentLegacyRouteFromSignals
	end

	local v10 = useStore()

	return React.useCallback(function() -- line: 28
		-- upvalues: selectCurrentLegacyRoute (copy), v10 (copy)
		return selectCurrentLegacyRoute(v10:getState())
	end, { v10 })
end

return useGetCurrentLegacyRoute
