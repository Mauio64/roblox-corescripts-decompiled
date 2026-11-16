local parent = script:FindFirstAncestor("AppChat").Parent

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
local Signals = require(parent.Signals)
local getLegacyNavigationStore

if FFlagSignalsNavP3hMisc then
	local NavigationRodux2 = require(parent.NavigationRodux)
	getLegacyNavigationStore = NavigationRodux2.GetLegacyNavigationStore
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

return function()
	if not FFlagSignalsNavP3hMisc then
		return useSelector(function(p): boolean
			if not p.Navigation then
				return true
			end

			if FFlagUseNavigationSelectors then
				return Selectors.selectCurrentPageName(p) == AppPage.Chat
			end

			local history = p.Navigation.history

			if not history then
				return false
			end

			local v = history[#history]
			return (v[#v] and v[#v].name) == AppPage.Chat
		end)
	end

	local legacyNavigationStore = getLegacyNavigationStore(false)
	return useSignalState((React.useMemo(function()
		return Signals.createComputed(function(p): boolean
			return not isNavigationAvailable() or legacyNavigationStore.getCurrentPageName(p) == AppPage.Chat
		end)
	end, {})))
end
