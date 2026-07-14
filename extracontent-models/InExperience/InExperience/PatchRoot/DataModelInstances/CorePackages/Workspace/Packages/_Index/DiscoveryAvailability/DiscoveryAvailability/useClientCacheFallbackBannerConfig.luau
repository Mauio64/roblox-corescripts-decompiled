local DiscoveryAvailability = script:FindFirstAncestor("DiscoveryAvailability")
local DiscoveryAvailabilityParent = DiscoveryAvailability.Parent
local React = require(DiscoveryAvailabilityParent.React)
local useSelector = require(DiscoveryAvailabilityParent.RoactUtils).Hooks.RoactRodux.useSelector
local useDispatch = require(DiscoveryAvailabilityParent.RoactUtils).Hooks.RoactRodux.useDispatch
local NavigationRodux = require(DiscoveryAvailabilityParent.NavigationRodux)
local selectCurrentRoactNavigationRoute = NavigationRodux.Selectors.selectCurrentRoactNavigationRoute
local GetLegacyNavigationStore = NavigationRodux.GetLegacyNavigationStore
local FFlagSignalsNavP3hMisc = require(DiscoveryAvailabilityParent.SharedFlags).FFlagSignalsNavP3hMisc
local AppPage = require(DiscoveryAvailabilityParent.RobloxAppEnums).AppPage
local RetrievalStatus = require(DiscoveryAvailabilityParent.Http).Enum.RetrievalStatus
local RobloxAppHooks = require(DiscoveryAvailabilityParent.RobloxAppHooks)

require(DiscoveryAvailabilityParent.LuauPolyfill)

local Promise = require(DiscoveryAvailabilityParent.Promise)
local SignalsReact = require(DiscoveryAvailabilityParent.SignalsReact)
local Signals = require(DiscoveryAvailability.Signals)
local useRoactService = RobloxAppHooks.useRoactService
local RoactNetworking = require(DiscoveryAvailabilityParent.RoactServiceTags).RoactNetworking
local AppOmniRecommendationsRequest = require(DiscoveryAvailabilityParent.RoactServiceTags).AppOmniRecommendationsRequest
local AppLogging = require(DiscoveryAvailabilityParent.RoactServiceTags).AppLogging
local DiscoveryEventErrorLogger = require(DiscoveryAvailabilityParent.DiscoveryUtils).DiscoveryEventErrorLogger
local OmniFeedConstants = require(DiscoveryAvailabilityParent.DiscoveryTypes).OmniFeedConstants

local function useClientCacheFallbackBannerConfig(p1: ((...any) -> ...any)) -- line: 41
	-- upvalues: useDispatch (copy), FFlagSignalsNavP3hMisc (copy), SignalsReact (copy), GetLegacyNavigationStore (copy), AppPage (copy), useSelector (copy), selectCurrentRoactNavigationRoute (copy), useRoactService (copy), RoactNetworking (copy), AppOmniRecommendationsRequest (copy), AppLogging (copy), Signals (copy), RetrievalStatus (copy), React (copy), OmniFeedConstants (copy), DiscoveryEventErrorLogger (copy), Promise (copy)
	local v24 = useDispatch()
	local u26

	if FFlagSignalsNavP3hMisc then
		local v25 = SignalsReact.useSignalState(GetLegacyNavigationStore(false).getCurrentPage)

		u26 = if not v25 then AppPage.Home else v25.name
	else
		local v27 = useSelector(selectCurrentRoactNavigationRoute)

		u26 = if not v27 then AppPage.Home else v27.routeName
	end

	local v28 = useRoactService(RoactNetworking)
	local v29 = useRoactService(AppOmniRecommendationsRequest)
	local v30 = useRoactService(AppLogging)
	local v31 = useSelector(function(p2) -- line: 58
		return p2.Startup.HomePageDataStatus
	end)
	local v32 = SignalsReact.useSignalState(Signals.getCacheStore().getHomePageDataSource)
	local v33 = u26 == AppPage.Home and (v31 == RetrievalStatus.Done and v32 == "Cache")
	local v34 = React.useCallback(function() -- line: 69
		-- upvalues: u26 (ref), AppPage (copy), v24 (copy), p1 (copy), v28 (copy), v29 (copy), OmniFeedConstants (copy), v30 (copy), DiscoveryEventErrorLogger (copy), Promise (copy)
		if u26 == AppPage.Home then
			return v24(p1(v28, v29, AppPage.Home, nil, nil, OmniFeedConstants.OmniRecommendationsRequestIntent.ManualRefresh, v30)):catch(function(p3) -- line: 83
				-- upvalues: DiscoveryEventErrorLogger (copy), Promise (copy)
				DiscoveryEventErrorLogger.reportError("ClientCacheFallbackBannerRefreshError", "Error refreshing omni recommendations")

				return Promise.reject(p3)
			end)
		end

		DiscoveryEventErrorLogger.reportError("ClientCacheFallbackBannerRefreshError", "Current page is not the home page")

		return Promise.reject()
	end, {
		v24,
		v28,
		v29,
		v30,
		u26
	})

	return {
		shouldShowBanner = v33,
		onRefreshButtonClick = v34
	}
end

return useClientCacheFallbackBannerConfig
