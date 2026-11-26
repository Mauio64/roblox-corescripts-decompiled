local React = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryRouting/React")
local useStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryRouting/RoactUtils").Hooks.RoactRodux.useStore
local NavigationRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryRouting/NavigationRodux")
local selectCurrentLegacyRoute = NavigationRodux.Selectors.selectCurrentLegacyRoute
local getLegacyNavigationStore = NavigationRodux.GetLegacyNavigationStore

local fFlagSignalsNavP2NavigationPrimitives = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryRouting/SharedFlags").FFlagSignalsNavP2NavigationPrimitives

local function getCurrentLegacyRouteFromSignals()
	return getLegacyNavigationStore(false).getCurrentLegacyRoute(false)
end

local function useGetCurrentLegacyRoute()
	if fFlagSignalsNavP2NavigationPrimitives then
		return getCurrentLegacyRouteFromSignals
	end

	local v5 = useStore()
	return React.useCallback(function()
		return selectCurrentLegacyRoute(v5:getState())
	end, { v5 })
end

return useGetCurrentLegacyRoute
