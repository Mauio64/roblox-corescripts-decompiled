local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialServerDrivenUi/React")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialServerDrivenUi/SharedFlags")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialServerDrivenUi/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialServerDrivenUi/SignalsReact")
local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialServerDrivenUi/SduiCoreSystem")
local PYMKCarousel = require("@game/CorePackages/Workspace/Packages/_Index/SocialServerDrivenUi/PYMKCarousel")
local friendRecommendations = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialServerDrivenUi/RecommendationsStore").FriendRecommendations

local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialServerDrivenUi/RobloxAppEnums").AppPage
local setCurrentToastMessage = require("@game/CorePackages/Workspace/Packages/_Index/SocialServerDrivenUi/ToastRodux").Actions.SetCurrentToastMessage
local PymkNavigationBridge = require("@game/CorePackages/Workspace/Packages/_Index/SocialServerDrivenUi/SocialServerDrivenUi/System/PymkNavigationBridge")
local normalizeDirectRecommendations = require("@game/CorePackages/Workspace/Packages/_Index/SocialServerDrivenUi/SocialServerDrivenUi/Common/normalizeDirectRecommendations")

local fFlagCreateConnectionsHub = SharedFlags.FFlagCreateConnectionsHub

local v5 = {}

local function readRecommendationHydration(items, store, p2)
	local recommendationHydration = {}

	for k, item in items do
		local data = store.getFriendRecommendation(item.id).data(p2)

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
	local store = friendRecommendations.getStore()

	local v7 = React.useMemo(function()
		return Signals.createComputed(function(p2)
			return normalizeDirectRecommendations(items, readRecommendationHydration(items, store, p2))
		end)
	end, { items, store })
	local v8 = SignalsReact.useSignalState(v7)

	local v9 = React.useMemo(function()
		return {
			sortIndex = v6,
			appPage = props.sduiContext.appPage,
			sortId = props.sortId,
			startRow = startRow
		}
	end, { v6, props.sduiContext.appPage, props.sortId, startRow })

	local v10 = React.useCallback(function(p2, p3)
		PymkNavigationBridge.requestOpenProfile(p2, p3)
	end, {})

	local v11 = React.useCallback(function(p2)
		dependencies.dispatch(setCurrentToastMessage({ toastMessage = p2 }))
	end, { dependencies.dispatch })

	local v12 = React.useCallback(function(p2)
		if fFlagCreateConnectionsHub then
			dependencies.getNavigation().navigate(appPage.CoHubAddConnections)
		else
			PymkNavigationBridge.requestOpenAddFriends()
		end
	end, { dependencies.getNavigation })

	return React.createElement(PYMKCarousel.PYMKCarouselEntryPoint, {
		key = props.recommendationRequestId,
		carouselTitle = props.title or "",
		recommendations = v8,
		recommendationSessionId = props.recommendationRequestId,
		openProfilePeekView = v10,
		showToast = v11,
		goToAddFriendsPage = v12,
		pageContext = props.sduiContext.appPage,
		scrollViewPositionChangedSignal = props.scrollViewPositionChangedSignal,
		sortAnalyticsData = v9,
		diagService = dependencies.appAnalytics.Diag,
		eventIngestService = dependencies.eventIngest,
		appCompositionEnabled = props.sduiContext.appCompositionEnabled
	})
end

return SduiPymkCarousel
