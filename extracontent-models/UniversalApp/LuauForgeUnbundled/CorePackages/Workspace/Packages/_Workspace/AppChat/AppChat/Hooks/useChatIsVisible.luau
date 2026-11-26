local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RobloxAppEnums").AppPage
local selectors = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/NavigationRodux").Selectors
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags")
local fFlagUseNavigationSelectors = SharedFlags.FFlagUseNavigationSelectors
local fFlagSignalsNavP3hMisc = SharedFlags.FFlagSignalsNavP3hMisc
local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils").Hooks.RoactRodux.useSelector

local useSignalState = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SignalsReact").useSignalState
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Signals")

local getLegacyNavigationStore = if fFlagSignalsNavP3hMisc then require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/NavigationRodux").GetLegacyNavigationStore else nil

local isNavigationAvailable = if fFlagSignalsNavP3hMisc then require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RobloxAppNavigation").isNavigationAvailable else nil

return function()
	if not fFlagSignalsNavP3hMisc then
		return useSelector(function(p2): boolean
			if not p2.Navigation then
				return true
			end

			if fFlagUseNavigationSelectors then
				return selectors.selectCurrentPageName(p2) == appPage.Chat
			end

			local history = p2.Navigation.history

			if not history then
				return false
			end

			local v5 = history[#history]
			return (v5[#v5] and v5[#v5].name) == appPage.Chat
		end)
	end

	local legacyNavigationStore = getLegacyNavigationStore(false)
	return useSignalState((React.useMemo(function()
		return Signals.createComputed(function(p2): boolean
			if isNavigationAvailable() then
				return legacyNavigationStore.getCurrentPageName(p2) == appPage.Chat
			end

			return true
		end)
	end, {})))
end
