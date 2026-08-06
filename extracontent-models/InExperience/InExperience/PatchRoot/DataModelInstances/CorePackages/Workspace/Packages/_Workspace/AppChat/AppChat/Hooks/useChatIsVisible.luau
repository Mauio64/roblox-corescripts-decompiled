local Parent = script:FindFirstAncestor("AppChat").Parent
local AppPage = require(Parent.RobloxAppEnums).AppPage
local Selectors = require(Parent.NavigationRodux).Selectors
local SharedFlags = require(Parent.SharedFlags)
local FFlagUseNavigationSelectors = SharedFlags.FFlagUseNavigationSelectors
local FFlagSignalsNavP3hMisc = SharedFlags.FFlagSignalsNavP3hMisc
local useSelector = require(Parent.RoactUtils).Hooks.RoactRodux.useSelector
local useSignalState = require(Parent.SignalsReact).useSignalState
local React = require(Parent.React)
local Signals = require(Parent.Signals)
local v11 = if not FFlagSignalsNavP3hMisc then nil else require(Parent.NavigationRodux).GetLegacyNavigationStore
local v12 = if not FFlagSignalsNavP3hMisc then nil else require(Parent.RobloxAppNavigation).isNavigationAvailable

return function() -- line: 27
	-- upvalues: FFlagSignalsNavP3hMisc (copy), v11 (copy), React (copy), Signals (copy), v12 (copy), AppPage (copy), useSignalState (copy), useSelector (copy), FFlagUseNavigationSelectors (copy), Selectors (copy)
	if FFlagSignalsNavP3hMisc then
		local v13 = v11(false)
		local v14 = React.useMemo(function() -- line: 30
			-- upvalues: Signals (copy), v12 (copy), v13 (copy), AppPage (copy)
			return Signals.createComputed(function(p1) -- line: 31
				-- upvalues: v12 (copy), v13 (copy), AppPage (copy)
				if not v12() then
					return true
				end

				return v13.getCurrentPageName(p1) == AppPage.Chat
			end)
		end, {})

		return useSignalState(v14)
	end

	return useSelector(function(p2) -- line: 40
		-- upvalues: FFlagUseNavigationSelectors (copy), Selectors (copy), AppPage (copy)
		if not p2.Navigation then
			return true
		end

		if FFlagUseNavigationSelectors then
			return Selectors.selectCurrentPageName(p2) == AppPage.Chat
		end

		local history = p2.Navigation.history

		if not history then
			return false
		end

		local v17 = history[#history]

		return (v17[#v17] and v17[#v17].name) == AppPage.Chat
	end)
end
