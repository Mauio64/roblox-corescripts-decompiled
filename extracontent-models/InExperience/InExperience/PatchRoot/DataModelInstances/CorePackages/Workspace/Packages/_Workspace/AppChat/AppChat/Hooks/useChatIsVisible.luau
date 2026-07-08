local Parent = script:FindFirstAncestor("AppChat").Parent
local AppPage = require(Parent.RobloxAppEnums).AppPage
local Selectors = require(Parent.NavigationRodux).Selectors
local SharedFlags = require(Parent.SharedFlags)
local FFlagUseNavigationSelectors = SharedFlags.FFlagUseNavigationSelectors
local FFlagSignalsNavP3hMisc = SharedFlags.FFlagSignalsNavP3hMisc
local useSelector = require(Parent.RoactUtils).Hooks.RoactRodux.useSelector
local useSignalState = require(Parent.SignalsReact).useSignalState
local v9 = if not FFlagSignalsNavP3hMisc then nil else require(Parent.NavigationRodux).GetLegacyNavigationStore

return function() -- line: 20
	-- upvalues: FFlagSignalsNavP3hMisc (copy), useSelector (copy), v9 (copy), useSignalState (copy), AppPage (copy), FFlagUseNavigationSelectors (copy), Selectors (copy)
	if FFlagSignalsNavP3hMisc then
		local v10 = useSelector(function(p1) -- line: 22
			return p1.Navigation ~= nil
		end)
		local v11 = v9(false)
		local v12 = useSignalState(v11.getCurrentPage)

		if not v10 then
			return true
		end

		return v12 ~= nil and v12.name == AppPage.Chat
	end

	return useSelector(function(p2) -- line: 33
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

		local v16 = history[#history]

		return (v16[#v16] and v16[#v16].name) == AppPage.Chat
	end)
end
