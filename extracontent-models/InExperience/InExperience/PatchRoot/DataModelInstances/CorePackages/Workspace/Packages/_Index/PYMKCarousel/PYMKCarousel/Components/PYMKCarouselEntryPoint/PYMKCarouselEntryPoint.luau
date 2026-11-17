local PYMKCarousel = script:FindFirstAncestor("PYMKCarousel")
local parent = PYMKCarousel.Parent

local dependencies = require(PYMKCarousel.dependencies)

local react = dependencies.React
local RobloxAppHooks = require(parent.RobloxAppHooks)
local SharedFlags = require(parent.SharedFlags)

local useSelector = dependencies.Hooks.useSelector
local useLocalUserId = RobloxAppHooks.useLocalUserId

local Analytics = require(PYMKCarousel.Analytics)
local setupFireEvent = Analytics.setupFireEvent
local getSessionIdByKey = dependencies.RoduxAnalytics.Selectors.getSessionIdByKey
local Constants = require(PYMKCarousel.Common.Constants)
local RECOMMENDATION_SESSION_ID_KEY = Constants.RECOMMENDATION_SESSION_ID_KEY
local Constants2 = require(PYMKCarousel.Common.Constants)
local HomepagePYMKCarouselSourceName = Constants2.HomepagePYMKCarouselSourceName

local PYMKCollectionCarousel = require(PYMKCarousel.Components.PYMKCollectionCarousel)

require(PYMKCarousel.Analytics.AnalyticsTypes)
require(PYMKCarousel.Common.DirectRecommendationTypes)

local FFlagLuaAppUserSeenCollectionUnifiedFields = SharedFlags.FFlagLuaAppUserSeenCollectionUnifiedFields
local FFlagLuaAppEnableSduiHomePage = SharedFlags.FFlagLuaAppEnableSduiHomePage
local FFlagPymkCarouselExtendProps = SharedFlags.FFlagPymkCarouselExtendProps

local function PYMKCarouselEntryPoint(props)
	local uid = useLocalUserId()
	local recommendationSessionId

	if FFlagLuaAppEnableSduiHomePage then
		recommendationSessionId = props.recommendationSessionId
	elseif FFlagPymkCarouselExtendProps then
		recommendationSessionId = useSelector(function(p)
			return getSessionIdByKey(p)(RECOMMENDATION_SESSION_ID_KEY)
		end)

		if props.recommendations then
			recommendationSessionId = props.recommendationSessionId
		end
	else
		recommendationSessionId = useSelector(function(p)
			return getSessionIdByKey(p)(RECOMMENDATION_SESSION_ID_KEY)
		end)
	end

	local useMemo = react.useMemo
	local function fn()
		local infoForAllEvents = {
			uid = uid,
			recommendationSessionId = recommendationSessionId,
			sortIndex = props.sortAnalyticsData.sortIndex,
			sortId = props.sortAnalyticsData.sortId,
			appPage = props.sortAnalyticsData.appPage,
			rowNumber = 1,
			feedRowNumber = props.sortAnalyticsData.startRow,
			source = 0
		}
		local source

		if FFlagPymkCarouselExtendProps then
			if props.analyticsSurface then
				source = props.analyticsSurface.source
			else
				source = HomepagePYMKCarouselSourceName
			end
		end

		infoForAllEvents.source = source
		local v = {
			infoForAllEvents = infoForAllEvents,
			analytics = { Diag = props.diagService, EventStream = props.eventIngestService },
			context = 0
		}
		local context

		if FFlagPymkCarouselExtendProps and props.analyticsSurface then
			context = props.analyticsSurface.context
		end

		v.context = context
		return setupFireEvent(v)
	end

	local sortAnalyticsData = props.sortAnalyticsData
	local v

	if FFlagPymkCarouselExtendProps then
		v = props.analyticsSurface
	end

	local fireAnalyticsEvent = useMemo(fn, { uid, recommendationSessionId, sortAnalyticsData, v })

	if not (uid and (recommendationSessionId or props.findFriendsTileEnabled)) then
		return nil
	end

	local createElement = react.createElement
	local v2 = {
		findFriendsTileEnabled = props.findFriendsTileEnabled,
		seeAllTileEnabled = props.seeAllTileEnabled,
		recommendationSessionId = recommendationSessionId,
		carouselTitle = props.carouselTitle,
		sideMargin = props.sideMargin,
		openProfilePeekView = props.openProfilePeekView,
		showToast = props.showToast,
		goToAddFriendsPage = props.goToAddFriendsPage,
		shouldShowContactImporterBadge = props.shouldShowContactImporterBadge,
		pageContext = props.pageContext,
		scrollViewPositionChangedSignal = props.scrollViewPositionChangedSignal,
		fireAnalyticsEvent = fireAnalyticsEvent,
		appCompositionEnabled = props.appCompositionEnabled,
		sortAnalyticsData = 0,
		recommendations = 0,
		onRecommendationsShown = 0,
		analyticsSurface = 0
	}
	local sortAnalyticsData2

	if FFlagLuaAppUserSeenCollectionUnifiedFields then
		sortAnalyticsData2 = props.sortAnalyticsData
	end

	v2.sortAnalyticsData = sortAnalyticsData2
	local recommendations

	if FFlagPymkCarouselExtendProps or FFlagLuaAppEnableSduiHomePage then
		recommendations = props.recommendations
	end

	v2.recommendations = recommendations
	local onRecommendationsShown

	if FFlagPymkCarouselExtendProps then
		onRecommendationsShown = props.onRecommendationsShown
	end

	v2.onRecommendationsShown = onRecommendationsShown
	local analyticsSurface

	if FFlagPymkCarouselExtendProps then
		analyticsSurface = props.analyticsSurface
	end

	v2.analyticsSurface = analyticsSurface
	return createElement(PYMKCollectionCarousel, v2)
end

return PYMKCarouselEntryPoint
