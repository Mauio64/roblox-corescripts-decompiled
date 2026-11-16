local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/dependencies")

local react = dependencies.React
local RobloxAppHooks = require("@game/CorePackages/Workspace/Packages/_Workspace/PYMKCarousel/RobloxAppHooks")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/PYMKCarousel/SharedFlags")

local useSelector = dependencies.Hooks.useSelector
local useLocalUserId = RobloxAppHooks.useLocalUserId

local setupFireEvent = require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/Analytics").setupFireEvent
local getSessionIdByKey = dependencies.RoduxAnalytics.Selectors.getSessionIdByKey
local RECOMMENDATION_SESSION_ID_KEY = require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/Common/Constants").RECOMMENDATION_SESSION_ID_KEY

local PYMKCollectionCarousel = require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/Components/PYMKCollectionCarousel")

require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/Analytics/AnalyticsTypes")
require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/Common/DirectRecommendationTypes")

local fFlagLuaAppUserSeenCollectionUnifiedFields = SharedFlags.FFlagLuaAppUserSeenCollectionUnifiedFields
local fFlagLuaAppEnableSduiHomePage = SharedFlags.FFlagLuaAppEnableSduiHomePage

local function PYMKCarouselEntryPoint(props)
	local v5 = useLocalUserId()
	local v6

	if fFlagLuaAppEnableSduiHomePage then
		v6 = props.recommendationSessionId
	else
		v6 = useSelector(function(p2)
			return getSessionIdByKey(p2)(RECOMMENDATION_SESSION_ID_KEY)
		end)
	end

	local v7 = react.useMemo(function()
		return setupFireEvent({
			infoForAllEvents = {
				uid = v5,
				recommendationSessionId = v6,
				sortIndex = props.sortAnalyticsData.sortIndex,
				sortId = props.sortAnalyticsData.sortId,
				appPage = props.sortAnalyticsData.appPage,
				rowNumber = 1,
				feedRowNumber = props.sortAnalyticsData.startRow
			},
			analytics = {
				Diag = props.diagService,
				EventStream = props.eventIngestService
			}
		})
	end, { v5, v6, props.sortAnalyticsData })

	if not (v5 and (v6 or props.findFriendsTileEnabled)) then
		return nil
	end

	local createElement = react.createElement
	local v9 = {
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
		fireAnalyticsEvent = v7,
		appCompositionEnabled = props.appCompositionEnabled,
		sortAnalyticsData = 0,
		recommendations = 0
	}

	local v10 = if fFlagLuaAppUserSeenCollectionUnifiedFields then props.sortAnalyticsData else nil
	v9.sortAnalyticsData = v10

	local v11 = if fFlagLuaAppEnableSduiHomePage then props.recommendations else nil
	v9.recommendations = v11
	return createElement(PYMKCollectionCarousel, v9)
end

return PYMKCarouselEntryPoint
