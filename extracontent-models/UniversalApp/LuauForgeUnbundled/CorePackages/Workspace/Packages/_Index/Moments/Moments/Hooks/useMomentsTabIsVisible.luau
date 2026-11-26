local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/RobloxAppEnums").AppPage
local NavigationRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/NavigationRodux")
local selectors = NavigationRodux.Selectors
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SharedFlags")
local fFlagUseNavigationSelectors = SharedFlags.FFlagUseNavigationSelectors
local fFlagSignalsNavP3hMisc = SharedFlags.FFlagSignalsNavP3hMisc
local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/RoactUtils").Hooks.RoactRodux.useSelector
local useSignalState = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SignalsReact").useSignalState
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")

local getLegacyNavigationStore = if fFlagSignalsNavP3hMisc then NavigationRodux.GetLegacyNavigationStore else nil

local isNavigationAvailable = if fFlagSignalsNavP3hMisc then require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/RobloxAppNavigation").isNavigationAvailable else nil

local function routeContainsMoments(items): boolean
	if type(items) ~= "table" then
		return false
	end

	for k, item in items do
		if type(item) == "table" and item.name == appPage.Moments then
			return true
		end
	end

	return false
end

local function useMomentsTabIsVisible()
	if not fFlagSignalsNavP3hMisc then
		return useSelector(function(p2)
			if not p2.Navigation then
				return true
			end

			if fFlagUseNavigationSelectors then
				return routeContainsMoments(selectors.selectCurrentLegacyRoute(p2))
			end

			local history = p2.Navigation.history

			if not history then
				return false
			end

			return routeContainsMoments(history[#history])
		end)
	end

	local legacyNavigationStore = getLegacyNavigationStore(false)
	local v6 = useSignalState((React.useMemo(function()
		return legacyNavigationStore.getRouteContainsPageSignal(appPage.Moments)
	end, {})))

	if isNavigationAvailable() then
		return v6
	end

	return true
end

return useMomentsTabIsVisible
