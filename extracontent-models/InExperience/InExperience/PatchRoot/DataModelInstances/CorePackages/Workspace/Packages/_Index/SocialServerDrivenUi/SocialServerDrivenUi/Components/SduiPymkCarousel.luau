local SocialServerDrivenUi = script:FindFirstAncestor("SocialServerDrivenUi")
local parent = SocialServerDrivenUi.Parent

local React = require(parent.React)
local SharedFlags = require(parent.SharedFlags)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)
local SduiCoreSystem = require(parent.SduiCoreSystem)
local PYMKCarousel = require(parent.PYMKCarousel)
local RecommendationsStore = require(parent.RecommendationsStore)
local FriendRecommendations = RecommendationsStore.FriendRecommendations

local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local ToastRodux = require(parent.ToastRodux)
local SetCurrentToastMessage = ToastRodux.Actions.SetCurrentToastMessage
local PymkNavigationBridge = require(SocialServerDrivenUi.System.PymkNavigationBridge)
local normalizeDirectRecommendations = require(SocialServerDrivenUi.Common.normalizeDirectRecommendations)

local FFlagCreateConnectionsHub = SharedFlags.FFlagCreateConnectionsHub

local v = {}

local function readRecommendationHydration(items, store, p)
	local recommendationHydration = {}

	for _, item in items do
		local data = store.getFriendRecommendation(item.id).data(p)

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
	local store = FriendRecommendations.getStore()

	local v2 = React.useMemo(function()
		return Signals.createComputed(function(p)
			return normalizeDirectRecommendations(items, readRecommendationHydration(items, store, p))
		end)
	end, { items, store })
	local recommendations = SignalsReact.useSignalState(v2)

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

	return React.createElement(PYMKCarousel.PYMKCarouselEntryPoint, {
		key = props.recommendationRequestId,
		carouselTitle = props.title or "",
		recommendations = recommendations,
		recommendationSessionId = props.recommendationRequestId,
		openProfilePeekView = openProfilePeekView,
		showToast = showToast,
		goToAddFriendsPage = goToAddFriendsPage,
		pageContext = props.sduiContext.appPage,
		scrollViewPositionChangedSignal = props.scrollViewPositionChangedSignal,
		sortAnalyticsData = sortAnalyticsData,
		diagService = dependencies.appAnalytics.Diag,
		eventIngestService = dependencies.eventIngest,
		appCompositionEnabled = props.sduiContext.appCompositionEnabled
	})
end

return SduiPymkCarousel
