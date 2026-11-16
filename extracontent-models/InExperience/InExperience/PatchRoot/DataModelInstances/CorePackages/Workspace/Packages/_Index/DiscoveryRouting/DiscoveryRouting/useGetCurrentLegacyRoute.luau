local parent = script:FindFirstAncestor("DiscoveryRouting").Parent

local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local useStore = RoactUtils.Hooks.RoactRodux.useStore
local NavigationRodux = require(parent.NavigationRodux)
local selectCurrentLegacyRoute = NavigationRodux.Selectors.selectCurrentLegacyRoute
local GetLegacyNavigationStore = NavigationRodux.GetLegacyNavigationStore

local SharedFlags = require(parent.SharedFlags)
local FFlagSignalsNavP2NavigationPrimitives = SharedFlags.FFlagSignalsNavP2NavigationPrimitives

local function getCurrentLegacyRouteFromSignals()
	return GetLegacyNavigationStore(false).getCurrentLegacyRoute(false)
end

local function useGetCurrentLegacyRoute()
	if FFlagSignalsNavP2NavigationPrimitives then
		return getCurrentLegacyRouteFromSignals
	end

	local v = useStore()
	return React.useCallback(function()
		return selectCurrentLegacyRoute(v:getState())
	end, { v })
end

return useGetCurrentLegacyRoute
