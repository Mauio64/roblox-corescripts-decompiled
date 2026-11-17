local SocialServerDrivenUi = script:FindFirstAncestor("SocialServerDrivenUi")
local parent = SocialServerDrivenUi.Parent

local React = require(parent.React)
local SharedFlags = require(parent.SharedFlags)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)
local SduiCoreSystem = require(parent.SduiCoreSystem)
local PYMKCarousel = require(parent.PYMKCarousel)
local FriendsRecommendations = require(parent.DataHydration.FriendsRecommendations)
local FriendRecommendations = FriendsRecommendations.FriendRecommendations

local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local ToastRodux = require(parent.ToastRodux)
local SetCurrentToastMessage = ToastRodux.Actions.SetCurrentToastMessage
local PymkNavigationBridge = require(SocialServerDrivenUi.System.PymkNavigationBridge)
local normalizeDirectRecommendations = require(SocialServerDrivenUi.Common.normalizeDirectRecommendations)

local FFlagCreateConnectionsHub = SharedFlags.FFlagCreateConnectionsHub
local FFlagLuaAppEnableSduiHomePage = SharedFlags.FFlagLuaAppEnableSduiHomePage
local FFlagPymkCarouselExtendProps = SharedFlags.FFlagPymkCarouselExtendProps

local v = {}

local function readRecommendationHydration(items, p, p2)
	local recommendationHydration = {}

	for _, item in items do
		local data = p.getFriendRecommendation(item.id).data(p2)

		if data then
			recommendationHydration[item.id] = data
		end
	end

	return recommendationHydration
end

local function SduiPymkCarousel(props)
	local items = props.items or v
	local analyticsData = props.analyticsContext.analyticsData or {}
	local dependencies = props.sduiContext.dependencies
	local sortIndex = tonumber(SduiCoreSystem.findAnalyticsField("collectionPosition", analyticsData, -1)) or -1
	local startRow = props.startRow or -1
	local v2

	if FFlagPymkCarouselExtendProps then
		v2 = FriendRecommendations.getStore(props.sduiContext.configKey)
	else
		v2 = FriendRecommendations.getStore()
	end

	local v3 = React.useMemo(function()
		return Signals.createComputed(function(p)
			return normalizeDirectRecommendations(items, readRecommendationHydration(items, v2, p))
		end)
	end, { items, v2 })
	local recommendations = SignalsReact.useSignalState(v3)

	local sortAnalyticsData = React.useMemo(function()
		return {
			sortIndex = sortIndex,
			appPage = props.sduiContext.appPage,
			sortId = props.sortId,
			startRow = startRow
		}
	end, { sortIndex, props.sduiContext.appPage, props.sortId, startRow })

	local openProfilePeekView = React.useCallback(function(p: string, p2)
		PymkNavigationBridge.requestOpenProfile(p, p2)
	end, {})

	local showToast = React.useCallback(function(toastMessage: string)
		dependencies.dispatch(SetCurrentToastMessage({ toastMessage = toastMessage }))
	end, { dependencies.dispatch })

	local goToAddFriendsPage = React.useCallback(function(_: boolean?)
		if FFlagCreateConnectionsHub then
			dependencies.getNavigation().navigate(AppPage.CoHubAddConnections)
		else
			PymkNavigationBridge.requestOpenAddFriends()
		end
	end, { dependencies.getNavigation })

	local createElement = React.createElement
	local pymkCarouselEntryPoint = PYMKCarousel.PYMKCarouselEntryPoint
	local v4 = {
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
		FFlagPymkCarouselExtendProps
		and not FFlagLuaAppEnableSduiHomePage
		and props.sduiContext.appPage == AppPage.Home
	then
		recommendations = nil
	end

	v4.recommendations = recommendations

	v4.recommendationSessionId = props.recommendationRequestId
	v4.openProfilePeekView = openProfilePeekView
	v4.showToast = showToast
	v4.goToAddFriendsPage = goToAddFriendsPage
	v4.pageContext = props.sduiContext.appPage
	v4.scrollViewPositionChangedSignal = props.scrollViewPositionChangedSignal
	v4.sortAnalyticsData = sortAnalyticsData
	v4.diagService = dependencies.appAnalytics.Diag
	v4.eventIngestService = dependencies.eventIngest
	v4.appCompositionEnabled = props.sduiContext.appCompositionEnabled
	local onRecommendationsShown

	if FFlagPymkCarouselExtendProps then
		onRecommendationsShown = props.onRecommendationsShown
	end

	v4.onRecommendationsShown = onRecommendationsShown
	local analyticsSurface

	if FFlagPymkCarouselExtendProps then
		analyticsSurface = props.analyticsSurface
	end

	v4.analyticsSurface = analyticsSurface
	return createElement(pymkCarouselEntryPoint, v4)
end

return SduiPymkCarousel
