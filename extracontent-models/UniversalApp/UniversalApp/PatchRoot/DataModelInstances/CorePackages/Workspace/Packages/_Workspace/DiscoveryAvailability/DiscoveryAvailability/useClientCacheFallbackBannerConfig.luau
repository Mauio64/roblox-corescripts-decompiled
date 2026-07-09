local DiscoveryAvailability = script:FindFirstAncestor("DiscoveryAvailability")
local DiscoveryAvailabilityParent = DiscoveryAvailability.Parent
local React = require(DiscoveryAvailabilityParent.React)
local useSelector = require(DiscoveryAvailabilityParent.RoactUtils).Hooks.RoactRodux.useSelector
local useDispatch = require(DiscoveryAvailabilityParent.RoactUtils).Hooks.RoactRodux.useDispatch
local selectCurrentRoactNavigationRoute = require(DiscoveryAvailabilityParent.NavigationRodux).Selectors.selectCurrentRoactNavigationRoute
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

local function useClientCacheFallbackBannerConfig(p1: ((...any) -> ...any)) -- line: 37
	-- upvalues: useDispatch (copy), useSelector (copy), selectCurrentRoactNavigationRoute (copy), AppPage (copy), useRoactService (copy), RoactNetworking (copy), AppOmniRecommendationsRequest (copy), AppLogging (copy), SignalsReact (copy), Signals (copy), RetrievalStatus (copy), React (copy), OmniFeedConstants (copy), DiscoveryEventErrorLogger (copy), Promise (copy)
	local v21 = useDispatch()
	local v22 = useSelector(selectCurrentRoactNavigationRoute)
	local v23 = if not v22 then AppPage.Home else v22.routeName
	local v24 = useRoactService(RoactNetworking)
	local v25 = useRoactService(AppOmniRecommendationsRequest)
	local v26 = useRoactService(AppLogging)
	local v27 = useSelector(function(p2) -- line: 48
		return p2.Startup.HomePageDataStatus
	end)
	local v28 = SignalsReact.useSignalState(Signals.getCacheStore().getHomePageDataSource)
	local v29 = v23 == AppPage.Home and (v27 == RetrievalStatus.Done and v28 == "Cache")
	local v30 = React.useCallback(function() -- line: 59
		-- upvalues: v23 (copy), AppPage (copy), v21 (copy), p1 (copy), v24 (copy), v25 (copy), OmniFeedConstants (copy), v26 (copy), DiscoveryEventErrorLogger (copy), Promise (copy)
		if v23 == AppPage.Home then
			return v21(p1(v24, v25, AppPage.Home, nil, nil, OmniFeedConstants.OmniRecommendationsRequestIntent.ManualRefresh, v26)):catch(function(p3) -- line: 73
				-- upvalues: DiscoveryEventErrorLogger (copy), Promise (copy)
				DiscoveryEventErrorLogger.reportError("ClientCacheFallbackBannerRefreshError", "Error refreshing omni recommendations")

				return Promise.reject(p3)
			end)
		end

		DiscoveryEventErrorLogger.reportError("ClientCacheFallbackBannerRefreshError", "Current page is not the home page")

		return Promise.reject()
	end, {
		v21,
		v24,
		v25,
		v26,
		v23
	})

	return {
		shouldShowBanner = v29,
		onRefreshButtonClick = v30
	}
end

return useClientCacheFallbackBannerConfig
