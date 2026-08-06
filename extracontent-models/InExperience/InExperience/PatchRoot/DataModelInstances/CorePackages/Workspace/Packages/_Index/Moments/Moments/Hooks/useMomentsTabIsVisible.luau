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
local React = require(Parent.React)
local v12 = if not FFlagSignalsNavP3hMisc then nil else NavigationRodux.GetLegacyNavigationStore
local v13 = if not FFlagSignalsNavP3hMisc then nil else require(Parent.RobloxAppNavigation).isNavigationAvailable

local function routeContainsMoments(p1) -- line: 36
	-- upvalues: AppPage (copy)
	if type(p1) ~= "table" then
		return false
	end

	for _, v18 in p1 do
		if type(v18) == "table" and v18.name == AppPage.Moments then
			return true
		end
	end

	return false
end
local function useMomentsTabIsVisible() -- line: 48
	-- upvalues: FFlagSignalsNavP3hMisc (copy), v12 (copy), React (copy), FFlagMomentsWatchSessionalization (copy), AppPage (copy), useSignalState (copy), v13 (copy), useSelector (copy), FFlagUseNavigationSelectors (copy), routeContainsMoments (copy), Selectors (copy)
	if FFlagSignalsNavP3hMisc then
		local v19 = v12(false)
		local v20 = React.useMemo(function() -- line: 51
			-- upvalues: FFlagMomentsWatchSessionalization (copy), v19 (copy), AppPage (copy)
			if FFlagMomentsWatchSessionalization then
				return v19.getRouteContainsPageSignal(AppPage.Moments)
			end

			return v19.getIsCurrentPageSignal(AppPage.Moments)
		end, {})
		local v21 = useSignalState(v20)

		if not v13() then
			return true
		end

		return v21
	end

	return useSelector(function(p2) -- line: 64
		-- upvalues: FFlagUseNavigationSelectors (copy), FFlagMomentsWatchSessionalization (copy), routeContainsMoments (copy), Selectors (copy), AppPage (copy)
		if not p2.Navigation then
			return true
		end

		if FFlagUseNavigationSelectors then
			if FFlagMomentsWatchSessionalization then
				return (routeContainsMoments(Selectors.selectCurrentLegacyRoute(p2)))
			end

			return Selectors.selectCurrentPageName(p2) == AppPage.Moments
		end

		local history = p2.Navigation.history

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
