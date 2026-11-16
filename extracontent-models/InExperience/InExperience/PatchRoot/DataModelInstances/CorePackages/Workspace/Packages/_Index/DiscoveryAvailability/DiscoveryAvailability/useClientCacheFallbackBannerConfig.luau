local DiscoveryAvailability = script:FindFirstAncestor("DiscoveryAvailability")
local parent = DiscoveryAvailability.Parent
local React = require(parent.React)

local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local RoactUtils2 = require(parent.RoactUtils)
local useDispatch = RoactUtils2.Hooks.RoactRodux.useDispatch
local NavigationRodux = require(parent.NavigationRodux)
local selectCurrentRoactNavigationRoute = NavigationRodux.Selectors.selectCurrentRoactNavigationRoute
local GetLegacyNavigationStore = NavigationRodux.GetLegacyNavigationStore
local SharedFlags = require(parent.SharedFlags)
local FFlagSignalsNavP3fGameDetails = SharedFlags.FFlagSignalsNavP3fGameDetails
local FFlagUseSignalsForStartup = SharedFlags.FFlagUseSignalsForStartup
local FFlagLuaAppEnableSduiHomePage = SharedFlags.FFlagLuaAppEnableSduiHomePage
local getStartupStore

if FFlagUseSignalsForStartup then
	local StartupStore = require(parent.StartupStore)
	getStartupStore = StartupStore.GetStartupStore
else
	getStartupStore = nil
end

local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local Http = require(parent.Http)
local RetrievalStatus = Http.Enum.RetrievalStatus
local RobloxAppHooks = require(parent.RobloxAppHooks)
require(parent.LuauPolyfill)
local Promise = require(parent.Promise)
local SignalsReact = require(parent.SignalsReact)
local Signals = require(parent.Signals)
local Signals2 = require(DiscoveryAvailability.Signals)
local useRoactService = RobloxAppHooks.useRoactService
local RoactServiceTags = require(parent.RoactServiceTags)
local RoactNetworking = RoactServiceTags.RoactNetworking
local RoactServiceTags2 = require(parent.RoactServiceTags)
local AppOmniRecommendationsRequest = RoactServiceTags2.AppOmniRecommendationsRequest
local RoactServiceTags3 = require(parent.RoactServiceTags)
local AppLogging = RoactServiceTags3.AppLogging
local DiscoveryUtils = require(parent.DiscoveryUtils)
local DiscoveryEventErrorLogger = DiscoveryUtils.DiscoveryEventErrorLogger

local DiscoveryTypes = require(parent.DiscoveryTypes)
local OmniFeedConstants = DiscoveryTypes.OmniFeedConstants

local function useClientCacheFallbackBannerConfig(callback, callback2)
	local v = useDispatch()
	local v2 = nil
	local v3 = nil

	if FFlagSignalsNavP3fGameDetails then
		local v4 = React.useMemo(function()
			return Signals.createComputed(function(p): boolean
				local currentRoute = GetLegacyNavigationStore(false).getCurrentRoute(p)
				local v4

				if currentRoute then
					v4 = currentRoute.routeName
				else
					v4 = AppPage.Home
				end

				local homePageDataSource = Signals2.getCacheStore().getHomePageDataSource(p)
				return v4 == AppPage.Home and homePageDataSource == "Cache"
			end)
		end, {})
		v3 = SignalsReact.useSignalState(v4)
	else
		local v4 = useSelector(selectCurrentRoactNavigationRoute)
		v2 = if v4 then v4.routeName else AppPage.Home
	end

	local v4 = useRoactService(RoactNetworking)
	local v5 = useRoactService(AppOmniRecommendationsRequest)
	local v6 = useRoactService(AppLogging)
	local v7

	if FFlagUseSignalsForStartup then
		v7 = SignalsReact.useSignalState(getStartupStore(false).getHomePageDataStatus)
	else
		v7 = useSelector(function(p)
			return p.Startup.HomePageDataStatus
		end)
	end

	local v8 = SignalsReact.useSignalState(Signals2.getCacheStore().getHomePageDataSource)
	local shouldShowBanner

	if FFlagSignalsNavP3fGameDetails then
		shouldShowBanner = v3 and v7 == RetrievalStatus.Done
	elseif v2 == AppPage.Home and v7 == RetrievalStatus.Done then
		shouldShowBanner = v8 == "Cache"
	else
		shouldShowBanner = false
	end

	local useCallback = React.useCallback
	local function fn()
		local v9

		if FFlagSignalsNavP3fGameDetails then
			local currentRoute = GetLegacyNavigationStore(false).getCurrentRoute(false)
			local v10

			if currentRoute then
				v10 = currentRoute.routeName
			else
				v10 = AppPage.Home
			end

			v9 = v10 == AppPage.Home
		else
			v9 = v2 == AppPage.Home
		end

		if not v9 then
			DiscoveryEventErrorLogger.reportError(
				"ClientCacheFallbackBannerRefreshError",
				"Current page is not the home page"
			)

			return Promise.reject()
		end

		if not FFlagLuaAppEnableSduiHomePage then
			return v(callback(
				v4,
				v5,
				AppPage.Home,
				nil,
				nil,
				OmniFeedConstants.OmniRecommendationsRequestIntent.ManualRefresh,
				v6
			)):catch(function(p)
				DiscoveryEventErrorLogger.reportError(
					"ClientCacheFallbackBannerRefreshError",
					"Error refreshing omni recommendations"
				)

				return Promise.reject(p)
			end)
		end

		local v10 = callback2()

		if v10 then
			return v10:catch(function(p)
				DiscoveryEventErrorLogger.reportError(
					"ClientCacheFallbackBannerRefreshError",
					"Error refreshing SDUI home page"
				)

				return Promise.reject(p)
			end)
		end

		return Promise.resolve()
	end

	local v9

	if FFlagLuaAppEnableSduiHomePage then
		v9 = callback
	end

	local v10

	if FFlagLuaAppEnableSduiHomePage then
		v10 = callback2
	end

	return {
		shouldShowBanner = shouldShowBanner,
		onRefreshButtonClick = useCallback(fn, { v, v4, v5, v6, v2, v9, v10 })
	}
end

return useClientCacheFallbackBannerConfig
