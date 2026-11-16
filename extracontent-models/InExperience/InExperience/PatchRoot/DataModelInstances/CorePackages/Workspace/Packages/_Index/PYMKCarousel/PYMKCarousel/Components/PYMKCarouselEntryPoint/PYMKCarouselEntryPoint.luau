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

local PYMKCollectionCarousel = require(PYMKCarousel.Components.PYMKCollectionCarousel)

require(PYMKCarousel.Analytics.AnalyticsTypes)
require(PYMKCarousel.Common.DirectRecommendationTypes)

local FFlagLuaAppUserSeenCollectionUnifiedFields = SharedFlags.FFlagLuaAppUserSeenCollectionUnifiedFields
local FFlagLuaAppEnableSduiHomePage = SharedFlags.FFlagLuaAppEnableSduiHomePage

local function PYMKCarouselEntryPoint(props)
	local uid = useLocalUserId()
	local recommendationSessionId

	if FFlagLuaAppEnableSduiHomePage then
		recommendationSessionId = props.recommendationSessionId
	else
		recommendationSessionId = useSelector(function(p)
			return getSessionIdByKey(p)(RECOMMENDATION_SESSION_ID_KEY)
		end)
	end

	local fireAnalyticsEvent = react.useMemo(function()
		return setupFireEvent({
			infoForAllEvents = {
				uid = uid,
				recommendationSessionId = recommendationSessionId,
				sortIndex = props.sortAnalyticsData.sortIndex,
				sortId = props.sortAnalyticsData.sortId,
				appPage = props.sortAnalyticsData.appPage,
				rowNumber = 1,
				feedRowNumber = props.sortAnalyticsData.startRow
			},
			analytics = { Diag = props.diagService, EventStream = props.eventIngestService }
		})
	end, { uid, recommendationSessionId, props.sortAnalyticsData })

	if not (uid and (recommendationSessionId or props.findFriendsTileEnabled)) then
		return nil
	end

	local createElement = react.createElement
	local v = {
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
		recommendations = 0
	}
	local sortAnalyticsData

	if FFlagLuaAppUserSeenCollectionUnifiedFields then
		sortAnalyticsData = props.sortAnalyticsData
	end

	v.sortAnalyticsData = sortAnalyticsData
	local recommendations

	if FFlagLuaAppEnableSduiHomePage then
		recommendations = props.recommendations
	end

	v.recommendations = recommendations
	return createElement(PYMKCollectionCarousel, v)
end

return PYMKCarouselEntryPoint
