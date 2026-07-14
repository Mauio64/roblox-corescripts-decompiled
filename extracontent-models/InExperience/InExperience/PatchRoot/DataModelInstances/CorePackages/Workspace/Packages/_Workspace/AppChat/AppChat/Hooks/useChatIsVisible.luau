local Parent = script:FindFirstAncestor("AppChat").Parent
local AppPage = require(Parent.RobloxAppEnums).AppPage
local Selectors = require(Parent.NavigationRodux).Selectors
local SharedFlags = require(Parent.SharedFlags)
local FFlagUseNavigationSelectors = SharedFlags.FFlagUseNavigationSelectors
local FFlagSignalsNavP3hMisc = SharedFlags.FFlagSignalsNavP3hMisc
local useSelector = require(Parent.RoactUtils).Hooks.RoactRodux.useSelector
local useSignalState = require(Parent.SignalsReact).useSignalState
local v9 = if not FFlagSignalsNavP3hMisc then nil else require(Parent.NavigationRodux).GetLegacyNavigationStore
local v10 = if not FFlagSignalsNavP3hMisc then nil else require(Parent.RobloxAppNavigation).isNavigationAvailable

return function() -- line: 25
	-- upvalues: FFlagSignalsNavP3hMisc (copy), v9 (copy), useSignalState (copy), v10 (copy), AppPage (copy), useSelector (copy), FFlagUseNavigationSelectors (copy), Selectors (copy)
	if FFlagSignalsNavP3hMisc then
		local v11 = v9(false)
		local v12 = useSignalState(v11.getCurrentPage)

		if not v10() then
			return true
		end

		return v12 ~= nil and v12.name == AppPage.Chat
	end

	return useSelector(function(p1) -- line: 35
		-- upvalues: FFlagUseNavigationSelectors (copy), Selectors (copy), AppPage (copy)
		if not p1.Navigation then
			return true
		end

		if FFlagUseNavigationSelectors then
			return Selectors.selectCurrentPageName(p1) == AppPage.Chat
		end

		local history = p1.Navigation.history

		if not history then
			return false
		end

		local v15 = history[#history]

		return (v15[#v15] and v15[#v15].name) == AppPage.Chat
	end)
end
