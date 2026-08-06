local DiscoveryAvailability = script:FindFirstAncestor("DiscoveryAvailability")
local DiscoveryAvailabilityParent = DiscoveryAvailability.Parent
local React = require(DiscoveryAvailabilityParent.React)
local useSelector = require(DiscoveryAvailabilityParent.RoactUtils).Hooks.RoactRodux.useSelector
local useDispatch = require(DiscoveryAvailabilityParent.RoactUtils).Hooks.RoactRodux.useDispatch
local NavigationRodux = require(DiscoveryAvailabilityParent.NavigationRodux)
local selectCurrentRoactNavigationRoute = NavigationRodux.Selectors.selectCurrentRoactNavigationRoute
local GetLegacyNavigationStore = NavigationRodux.GetLegacyNavigationStore
local FFlagSignalsNavP3fGameDetails = require(DiscoveryAvailabilityParent.SharedFlags).FFlagSignalsNavP3fGameDetails
local AppPage = require(DiscoveryAvailabilityParent.RobloxAppEnums).AppPage
local RetrievalStatus = require(DiscoveryAvailabilityParent.Http).Enum.RetrievalStatus
local RobloxAppHooks = require(DiscoveryAvailabilityParent.RobloxAppHooks)

require(DiscoveryAvailabilityParent.LuauPolyfill)

local Promise = require(DiscoveryAvailabilityParent.Promise)
local SignalsReact = require(DiscoveryAvailabilityParent.SignalsReact)
local Signals = require(DiscoveryAvailabilityParent.Signals)
local Signals2 = require(DiscoveryAvailability.Signals)
local useRoactService = RobloxAppHooks.useRoactService
local RoactNetworking = require(DiscoveryAvailabilityParent.RoactServiceTags).RoactNetworking
local AppOmniRecommendationsRequest = require(DiscoveryAvailabilityParent.RoactServiceTags).AppOmniRecommendationsRequest
local AppLogging = require(DiscoveryAvailabilityParent.RoactServiceTags).AppLogging
local DiscoveryEventErrorLogger = require(DiscoveryAvailabilityParent.DiscoveryUtils).DiscoveryEventErrorLogger
local OmniFeedConstants = require(DiscoveryAvailabilityParent.DiscoveryTypes).OmniFeedConstants

local function useClientCacheFallbackBannerConfig(p1: ((...any) -> ...any)) -- line: 42
	-- upvalues: useDispatch (copy), FFlagSignalsNavP3fGameDetails (copy), React (copy), Signals (copy), GetLegacyNavigationStore (copy), AppPage (copy), Signals2 (copy), SignalsReact (copy), useSelector (copy), selectCurrentRoactNavigationRoute (copy), useRoactService (copy), RoactNetworking (copy), AppOmniRecommendationsRequest (copy), AppLogging (copy), RetrievalStatus (copy), OmniFeedConstants (copy), DiscoveryEventErrorLogger (copy), Promise (copy)
	local v25 = useDispatch()
	local u26 = nil
	local v27 = nil

	if FFlagSignalsNavP3fGameDetails then
		local v28 = React.useMemo(function() -- line: 49
			-- upvalues: Signals (copy), GetLegacyNavigationStore (copy), AppPage (copy), Signals2 (copy)
			return Signals.createComputed(function(p2) -- line: 50
				-- upvalues: GetLegacyNavigationStore (copy), AppPage (copy), Signals2 (copy)
				local v41 = GetLegacyNavigationStore(false).getCurrentRoute(p2)
				local v42 = if not v41 then AppPage.Home else v41.routeName
				local v43 = Signals2.getCacheStore().getHomePageDataSource(p2)

				return v42 == AppPage.Home and v43 == "Cache"
			end)
		end, {})

		v27 = SignalsReact.useSignalState(v28)
	else
		local v29 = useSelector(selectCurrentRoactNavigationRoute)

		u26 = if not v29 then AppPage.Home else v29.routeName
	end

	local v30 = useRoactService(RoactNetworking)
	local v31 = useRoactService(AppOmniRecommendationsRequest)
	local v32 = useRoactService(AppLogging)
	local v33 = useSelector(function(p3) -- line: 67
		return p3.Startup.HomePageDataStatus
	end)
	local v34 = SignalsReact.useSignalState(Signals2.getCacheStore().getHomePageDataSource)
	local v35 = if not FFlagSignalsNavP3fGameDetails then u26 == AppPage.Home and (v33 == RetrievalStatus.Done and v34 == "Cache") else v27 and v33 == RetrievalStatus.Done
	local v36 = React.useCallback(function() -- line: 80
		-- upvalues: FFlagSignalsNavP3fGameDetails (copy), GetLegacyNavigationStore (copy), AppPage (copy), u26 (ref), v25 (copy), p1 (copy), v30 (copy), v31 (copy), OmniFeedConstants (copy), v32 (copy), DiscoveryEventErrorLogger (copy), Promise (copy)
		local v39

		if FFlagSignalsNavP3fGameDetails then
			local v38 = GetLegacyNavigationStore(false).getCurrentRoute(false)

			v39 = ((if not v38 then AppPage.Home else v38.routeName)) == AppPage.Home
		else
			v39 = u26 == AppPage.Home
		end

		if v39 then
			return v25(p1(v30, v31, AppPage.Home, nil, nil, OmniFeedConstants.OmniRecommendationsRequestIntent.ManualRefresh, v32)):catch(function(p4) -- line: 102
				-- upvalues: DiscoveryEventErrorLogger (copy), Promise (copy)
				DiscoveryEventErrorLogger.reportError("ClientCacheFallbackBannerRefreshError", "Error refreshing omni recommendations")

				return Promise.reject(p4)
			end)
		end

		DiscoveryEventErrorLogger.reportError("ClientCacheFallbackBannerRefreshError", "Current page is not the home page")

		return Promise.reject()
	end, {
		v25,
		v30,
		v31,
		v32,
		u26
	})

	return {
		shouldShowBanner = v35,
		onRefreshButtonClick = v36
	}
end

return useClientCacheFallbackBannerConfig
