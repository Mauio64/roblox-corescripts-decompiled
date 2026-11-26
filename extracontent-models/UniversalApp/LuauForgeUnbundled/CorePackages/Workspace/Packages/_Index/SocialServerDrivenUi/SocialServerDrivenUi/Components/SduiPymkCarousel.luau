local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialServerDrivenUi/React")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialServerDrivenUi/SharedFlags")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialServerDrivenUi/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialServerDrivenUi/SignalsReact")
local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialServerDrivenUi/SduiCoreSystem")
local PYMKCarousel = require("@game/CorePackages/Workspace/Packages/_Index/SocialServerDrivenUi/PYMKCarousel")
local friendRecommendations = require("@game/CorePackages/Workspace/Packages/_Index/SocialServerDrivenUi/DataHydration/FriendsRecommendations").FriendRecommendations

local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialServerDrivenUi/RobloxAppEnums").AppPage
local setCurrentToastMessage = require("@game/CorePackages/Workspace/Packages/_Index/SocialServerDrivenUi/ToastRodux").Actions.SetCurrentToastMessage
local PymkNavigationBridge = require("@game/CorePackages/Workspace/Packages/_Index/SocialServerDrivenUi/SocialServerDrivenUi/System/PymkNavigationBridge")
local normalizeDirectRecommendations = require("@game/CorePackages/Workspace/Packages/_Index/SocialServerDrivenUi/SocialServerDrivenUi/Common/normalizeDirectRecommendations")

local fFlagCreateConnectionsHub = SharedFlags.FFlagCreateConnectionsHub
local fFlagLuaAppEnableSduiHomePage = SharedFlags.FFlagLuaAppEnableSduiHomePage
local fFlagPymkCarouselExtendProps = SharedFlags.FFlagPymkCarouselExtendProps

local v5 = {}

local function readRecommendationHydration(items, p2, p3)
	local recommendationHydration = {}

	for k, item in items do
		local data = p2.getFriendRecommendation(item.id).data(p3)

		if data then
			recommendationHydration[item.id] = data
		end
	end

	return recommendationHydration
end

local function SduiPymkCarousel(props)
	local items = props.items or v5
	local analyticsData = props.analyticsContext.analyticsData or {}
	local dependencies = props.sduiContext.dependencies
	local v6 = tonumber(SduiCoreSystem.findAnalyticsField("collectionPosition", analyticsData, -1)) or -1
	local startRow = props.startRow or -1
	local v7

	if fFlagPymkCarouselExtendProps then
		v7 = friendRecommendations.getStore(props.sduiContext.configKey)
	else
		v7 = friendRecommendations.getStore()
	end

	local v8 = React.useMemo(function()
		return Signals.createComputed(function(p2)
			return normalizeDirectRecommendations(items, readRecommendationHydration(items, v7, p2))
		end)
	end, { items, v7 })
	local v9 = SignalsReact.useSignalState(v8)

	local v10 = React.useMemo(function()
		return {
			sortIndex = v6,
			appPage = props.sduiContext.appPage,
			sortId = props.sortId,
			startRow = startRow
		}
	end, { v6, props.sduiContext.appPage, props.sortId, startRow })

	local v11 = React.useCallback(function(p2, p3)
		PymkNavigationBridge.requestOpenProfile(p2, p3)
	end, {})

	local v12 = React.useCallback(function(p2)
		dependencies.dispatch(setCurrentToastMessage({ toastMessage = p2 }))
	end, { dependencies.dispatch })

	local v13 = React.useCallback(function(p2)
		if fFlagCreateConnectionsHub then
			dependencies.getNavigation().navigate(appPage.CoHubAddConnections)
		else
			PymkNavigationBridge.requestOpenAddFriends()
		end
	end, { dependencies.getNavigation })

	local createElement = React.createElement
	local pymkCarouselEntryPoint = PYMKCarousel.PYMKCarouselEntryPoint
	local v14 = {
		key = props.recommendationRequestId,
		carouselTitle = props.title or "",
		recommendations = 0,
		recommendationSessionId = 0,
		openProfilePeekView = 0,
		showToast = 0,
		goToAddFriendsPage = 0,
		pageContext = 0,
		scrollViewPositionChangedSignal = 0,
		sortAnalyticsData = 0,
		diagService = 0,
		eventIngestService = 0,
		appCompositionEnabled = 0,
		onRecommendationsShown = 0,
		analyticsSurface = 0
	}

	if
		fFlagPymkCarouselExtendProps
		and not fFlagLuaAppEnableSduiHomePage
		and props.sduiContext.appPage == appPage.Home
	then
		v9 = nil
	end

	v14.recommendations = v9

	v14.recommendationSessionId = props.recommendationRequestId
	v14.openProfilePeekView = v11
	v14.showToast = v12
	v14.goToAddFriendsPage = v13
	v14.pageContext = props.sduiContext.appPage
	v14.scrollViewPositionChangedSignal = props.scrollViewPositionChangedSignal
	v14.sortAnalyticsData = v10
	v14.diagService = dependencies.appAnalytics.Diag
	v14.eventIngestService = dependencies.eventIngest
	v14.appCompositionEnabled = props.sduiContext.appCompositionEnabled
	local v15 = if fFlagPymkCarouselExtendProps then props.onRecommendationsShown else nil
	v14.onRecommendationsShown = v15
	local v16 = if fFlagPymkCarouselExtendProps then props.analyticsSurface else nil
	v14.analyticsSurface = v16
	return createElement(pymkCarouselEntryPoint, v14)
end

return SduiPymkCarousel
