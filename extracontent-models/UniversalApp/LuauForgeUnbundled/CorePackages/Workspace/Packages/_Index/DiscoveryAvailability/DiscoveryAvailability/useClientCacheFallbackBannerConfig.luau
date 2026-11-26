local React = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryAvailability/React")

local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryAvailability/RoactUtils").Hooks.RoactRodux.useSelector
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryAvailability/RoactUtils").Hooks.RoactRodux.useDispatch
local NavigationRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryAvailability/NavigationRodux")
local selectCurrentRoactNavigationRoute = NavigationRodux.Selectors.selectCurrentRoactNavigationRoute
local getLegacyNavigationStore = NavigationRodux.GetLegacyNavigationStore
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryAvailability/SharedFlags")
local fFlagSignalsNavP3fGameDetails = SharedFlags.FFlagSignalsNavP3fGameDetails
local fFlagUseSignalsForStartup = SharedFlags.FFlagUseSignalsForStartup
local fFlagLuaAppEnableSduiHomePage = SharedFlags.FFlagLuaAppEnableSduiHomePage

local getStartupStore = if fFlagUseSignalsForStartup then require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryAvailability/StartupStore").GetStartupStore else nil

local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryAvailability/RobloxAppEnums").AppPage
local retrievalStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryAvailability/Http").Enum.RetrievalStatus
local RobloxAppHooks = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryAvailability/RobloxAppHooks")
require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryAvailability/LuauPolyfill")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryAvailability/Promise")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryAvailability/SignalsReact")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryAvailability/Signals")
local module8 = require("@game/CorePackages/Workspace/Packages/_Index/DiscoveryAvailability/DiscoveryAvailability/Signals")
local useRoactService = RobloxAppHooks.useRoactService
local roactNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryAvailability/RoactServiceTags").RoactNetworking
local appOmniRecommendationsRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryAvailability/RoactServiceTags").AppOmniRecommendationsRequest
local appLogging = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryAvailability/RoactServiceTags").AppLogging
local discoveryEventErrorLogger = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryAvailability/DiscoveryUtils").DiscoveryEventErrorLogger

local omniFeedConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryAvailability/DiscoveryTypes").OmniFeedConstants

local function useClientCacheFallbackBannerConfig(callback, callback2)
	local v5 = useDispatch()
	local v6 = nil
	local v7 = nil

	if fFlagSignalsNavP3fGameDetails then
		local v8 = React.useMemo(function()
			return Signals.createComputed(function(p2): boolean
				local currentRoute = getLegacyNavigationStore(false).getCurrentRoute(p2)
				local v9 = if currentRoute then currentRoute.routeName else appPage.Home
				local homePageDataSource = module8.getCacheStore().getHomePageDataSource(p2)
				return v9 == appPage.Home and homePageDataSource == "Cache"
			end)
		end, {})
		v7 = SignalsReact.useSignalState(v8)
	else
		local v8 = useSelector(selectCurrentRoactNavigationRoute)
		v6 = if v8 then v8.routeName else appPage.Home
	end

	local v8 = useRoactService(roactNetworking)
	local v9 = useRoactService(appOmniRecommendationsRequest)
	local v10 = useRoactService(appLogging)
	local v11

	if fFlagUseSignalsForStartup then
		v11 = SignalsReact.useSignalState(getStartupStore(false).getHomePageDataStatus)
	else
		v11 = useSelector(function(p2)
			return p2.Startup.HomePageDataStatus
		end)
	end

	local v12 = SignalsReact.useSignalState(module8.getCacheStore().getHomePageDataSource)
	local v13

	if fFlagSignalsNavP3fGameDetails then
		v13 = v7 and v11 == retrievalStatus.Done
	else
		v13 = v6 == appPage.Home and v11 == retrievalStatus.Done and v12 == "Cache"
	end

	local useCallback = React.useCallback
	local function fn()
		local v14

		if fFlagSignalsNavP3fGameDetails then
			local currentRoute = getLegacyNavigationStore(false).getCurrentRoute(false)
			v14 = (if currentRoute then currentRoute.routeName else appPage.Home) == appPage.Home
		else
			v14 = v6 == appPage.Home
		end

		if not v14 then
			discoveryEventErrorLogger.reportError(
				"ClientCacheFallbackBannerRefreshError",
				"Current page is not the home page"
			)

			return Promise.reject()
		end

		if not fFlagLuaAppEnableSduiHomePage then
			return v5(callback(
				v8,
				v9,
				appPage.Home,
				nil,
				nil,
				omniFeedConstants.OmniRecommendationsRequestIntent.ManualRefresh,
				v10
			)):catch(function(p2)
				discoveryEventErrorLogger.reportError(
					"ClientCacheFallbackBannerRefreshError",
					"Error refreshing omni recommendations"
				)

				return Promise.reject(p2)
			end)
		end

		local v15 = callback2()

		if v15 then
			return v15:catch(function(p2)
				discoveryEventErrorLogger.reportError(
					"ClientCacheFallbackBannerRefreshError",
					"Error refreshing SDUI home page"
				)

				return Promise.reject(p2)
			end)
		end

		return Promise.resolve()
	end

	local v16 = if fFlagLuaAppEnableSduiHomePage then callback else nil
	return {
		shouldShowBanner = v13,
		onRefreshButtonClick = useCallback(fn, {
			v5,
			v8,
			v9,
			v10,
			v6,
			v16,
			if fFlagLuaAppEnableSduiHomePage then callback2 else nil
		})
	}
end

return useClientCacheFallbackBannerConfig
