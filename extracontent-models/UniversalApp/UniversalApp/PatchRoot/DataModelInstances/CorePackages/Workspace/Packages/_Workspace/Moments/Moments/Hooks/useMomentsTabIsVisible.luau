local Parent = script:FindFirstAncestor("Moments").Parent
local AppPage = require(Parent.RobloxAppEnums).AppPage
local NavigationRodux = require(Parent.NavigationRodux)
local Selectors = NavigationRodux.Selectors
local SharedFlags = require(Parent.SharedFlags)
local FFlagUseNavigationSelectors = SharedFlags.FFlagUseNavigationSelectors
local FFlagSignalsNavP3hMisc = SharedFlags.FFlagSignalsNavP3hMisc
local FFlagMomentsWatchSessionalization = SharedFlags.FFlagMomentsWatchSessionalization
local useSelector = require(Parent.RoactUtils).Hooks.RoactRodux.useSelector
local useSignalState = require(Parent.SignalsReact).useSignalState
local v11 = if not FFlagSignalsNavP3hMisc then nil else NavigationRodux.GetLegacyNavigationStore

local function routeContainsMoments(p1) -- line: 32
	-- upvalues: AppPage (copy)
	if type(p1) ~= "table" then
		return false
	end

	for _, v16 in p1 do
		if type(v16) == "table" and v16.name == AppPage.Moments then
			return true
		end
	end

	return false
end
local function useMomentsTabIsVisible() -- line: 44
	-- upvalues: FFlagSignalsNavP3hMisc (copy), useSelector (copy), v11 (copy), useSignalState (copy), FFlagMomentsWatchSessionalization (copy), routeContainsMoments (copy), AppPage (copy), FFlagUseNavigationSelectors (copy), Selectors (copy)
	if FFlagSignalsNavP3hMisc then
		local v17 = useSelector(function(p2) -- line: 46
			return p2.Navigation ~= nil
		end)
		local v18 = v11(false)
		local v19 = useSignalState(v18.getCurrentLegacyRoute)

		if not v17 then
			return true
		end

		if FFlagMomentsWatchSessionalization then
			return (routeContainsMoments(v19))
		end

		local v20 = if not v19 then nil else v19[#v19]

		return v20 ~= nil and v20.name == AppPage.Moments
	end

	return useSelector(function(p3) -- line: 61
		-- upvalues: FFlagUseNavigationSelectors (copy), FFlagMomentsWatchSessionalization (copy), routeContainsMoments (copy), Selectors (copy), AppPage (copy)
		if not p3.Navigation then
			return true
		end

		if FFlagUseNavigationSelectors then
			if FFlagMomentsWatchSessionalization then
				return (routeContainsMoments(Selectors.selectCurrentLegacyRoute(p3)))
			end

			return Selectors.selectCurrentPageName(p3) == AppPage.Moments
		end

		local history = p3.Navigation.history

		if not history then
			return false
		end

		local v24 = history[#history]

		if FFlagMomentsWatchSessionalization then
			return (routeContainsMoments(v24))
		end

		return (v24[#v24] and v24[#v24].name) == AppPage.Moments
	end)
end

return useMomentsTabIsVisible
