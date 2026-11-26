local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/dependencies")

local react = dependencies.React
local RobloxAppHooks = require("@game/CorePackages/Workspace/Packages/_Workspace/PYMKCarousel/RobloxAppHooks")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/PYMKCarousel/SharedFlags")

local useSelector = dependencies.Hooks.useSelector
local useLocalUserId = RobloxAppHooks.useLocalUserId

local setupFireEvent = require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/Analytics").setupFireEvent
local getSessionIdByKey = dependencies.RoduxAnalytics.Selectors.getSessionIdByKey
local RECOMMENDATION_SESSION_ID_KEY = require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/Common/Constants").RECOMMENDATION_SESSION_ID_KEY
local homepagePYMKCarouselSourceName = require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/Common/Constants").HomepagePYMKCarouselSourceName

local PYMKCollectionCarousel = require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/Components/PYMKCollectionCarousel")

require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/Analytics/AnalyticsTypes")
require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/Common/DirectRecommendationTypes")

local fFlagLuaAppUserSeenCollectionUnifiedFields = SharedFlags.FFlagLuaAppUserSeenCollectionUnifiedFields
local fFlagLuaAppEnableSduiHomePage = SharedFlags.FFlagLuaAppEnableSduiHomePage
local fFlagPymkCarouselExtendProps = SharedFlags.FFlagPymkCarouselExtendProps

local function PYMKCarouselEntryPoint(props)
	local v5 = useLocalUserId()
	local v6

	if fFlagLuaAppEnableSduiHomePage then
		v6 = props.recommendationSessionId
	elseif fFlagPymkCarouselExtendProps then
		v6 = useSelector(function(p2)
			return getSessionIdByKey(p2)(RECOMMENDATION_SESSION_ID_KEY)
		end)

		if props.recommendations then
			v6 = props.recommendationSessionId
		end
	else
		v6 = useSelector(function(p2)
			return getSessionIdByKey(p2)(RECOMMENDATION_SESSION_ID_KEY)
		end)
	end

	local useMemo = react.useMemo
	local function fn()
		local v9 = {
			uid = v5,
			recommendationSessionId = v6,
			sortIndex = props.sortAnalyticsData.sortIndex,
			sortId = props.sortAnalyticsData.sortId,
			appPage = props.sortAnalyticsData.appPage,
			rowNumber = 1,
			feedRowNumber = props.sortAnalyticsData.startRow,
			source = 0
		}
		local v10

		if fFlagPymkCarouselExtendProps then
			if props.analyticsSurface then
				v10 = props.analyticsSurface.source
			else
				v10 = homepagePYMKCarouselSourceName
			end
		end

		v9.source = v10
		local v8 = {
			infoForAllEvents = v9,
			analytics = {
				Diag = props.diagService,
				EventStream = props.eventIngestService
			},
			context = 0
		}

		local v11 = if fFlagPymkCarouselExtendProps and props.analyticsSurface then props.analyticsSurface.context else nil
		v8.context = v11
		return setupFireEvent(v8)
	end

	local sortAnalyticsData = props.sortAnalyticsData
	local v9 = if fFlagPymkCarouselExtendProps then props.analyticsSurface else nil
	local v10 = useMemo(fn, { v5, v6, sortAnalyticsData, v9 })

	if not (v5 and (v6 or props.findFriendsTileEnabled)) then
		return nil
	end

	local createElement = react.createElement
	local v12 = {
		findFriendsTileEnabled = props.findFriendsTileEnabled,
		seeAllTileEnabled = props.seeAllTileEnabled,
		recommendationSessionId = v6,
		carouselTitle = props.carouselTitle,
		sideMargin = props.sideMargin,
		openProfilePeekView = props.openProfilePeekView,
		showToast = props.showToast,
		goToAddFriendsPage = props.goToAddFriendsPage,
		shouldShowContactImporterBadge = props.shouldShowContactImporterBadge,
		pageContext = props.pageContext,
		scrollViewPositionChangedSignal = props.scrollViewPositionChangedSignal,
		fireAnalyticsEvent = v10,
		appCompositionEnabled = props.appCompositionEnabled,
		sortAnalyticsData = 0,
		recommendations = 0,
		onRecommendationsShown = 0,
		analyticsSurface = 0
	}

	local v13 = if fFlagLuaAppUserSeenCollectionUnifiedFields then props.sortAnalyticsData else nil
	v12.sortAnalyticsData = v13

	local v14 = if fFlagPymkCarouselExtendProps or fFlagLuaAppEnableSduiHomePage then props.recommendations else nil
	v12.recommendations = v14

	local v15 = if fFlagPymkCarouselExtendProps then props.onRecommendationsShown else nil
	v12.onRecommendationsShown = v15
	local v16 = if fFlagPymkCarouselExtendProps then props.analyticsSurface else nil
	v12.analyticsSurface = v16
	return createElement(PYMKCollectionCarousel, v12)
end

return PYMKCarouselEntryPoint
