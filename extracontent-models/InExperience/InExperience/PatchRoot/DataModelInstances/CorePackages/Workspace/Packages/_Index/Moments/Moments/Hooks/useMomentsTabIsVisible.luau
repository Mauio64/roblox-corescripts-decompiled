local parent = script:FindFirstAncestor("Moments").Parent

local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local NavigationRodux = require(parent.NavigationRodux)
local Selectors = NavigationRodux.Selectors
local SharedFlags = require(parent.SharedFlags)
local FFlagUseNavigationSelectors = SharedFlags.FFlagUseNavigationSelectors
local FFlagSignalsNavP3hMisc = SharedFlags.FFlagSignalsNavP3hMisc
local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local SignalsReact = require(parent.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local React = require(parent.React)
local getLegacyNavigationStore

if FFlagSignalsNavP3hMisc then
	getLegacyNavigationStore = NavigationRodux.GetLegacyNavigationStore
else
	getLegacyNavigationStore = nil
end

local isNavigationAvailable

if FFlagSignalsNavP3hMisc then
	local RobloxAppNavigation = require(parent.RobloxAppNavigation)
	isNavigationAvailable = RobloxAppNavigation.isNavigationAvailable
else
	isNavigationAvailable = nil
end

local function routeContainsMoments(items): boolean
	if type(items) ~= "table" then
		return false
	end

	for _, item in items do
		if type(item) == "table" and item.name == AppPage.Moments then
			return true
		end
	end

	return false
end

local function useMomentsTabIsVisible()
	if not FFlagSignalsNavP3hMisc then
		return useSelector(function(p)
			if not p.Navigation then
				return true
			end

			if FFlagUseNavigationSelectors then
				return routeContainsMoments(Selectors.selectCurrentLegacyRoute(p))
			end

			local history = p.Navigation.history

			return not not history and routeContainsMoments(history[#history])
		end)
	end

	local legacyNavigationStore = getLegacyNavigationStore(false)
	local v = useSignalState((React.useMemo(function()
		return legacyNavigationStore.getRouteContainsPageSignal(AppPage.Moments)
	end, {})))

	return not isNavigationAvailable() or v
end

return useMomentsTabIsVisible
