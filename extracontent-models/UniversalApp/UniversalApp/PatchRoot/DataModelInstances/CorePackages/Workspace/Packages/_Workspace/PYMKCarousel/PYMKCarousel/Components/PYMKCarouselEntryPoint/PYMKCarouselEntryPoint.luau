local PYMKCarousel = script:FindFirstAncestor("PYMKCarousel")
local PYMKCarouselParent = PYMKCarousel.Parent
local dependencies = require(PYMKCarousel.dependencies)
local React = dependencies.React
local RobloxAppHooks = require(PYMKCarouselParent.RobloxAppHooks)
local useSelector = dependencies.Hooks.useSelector
local useLocalUserId = RobloxAppHooks.useLocalUserId
local setupFireEvent = require(PYMKCarousel.Analytics).setupFireEvent
local getSessionIdByKey = dependencies.RoduxAnalytics.Selectors.getSessionIdByKey
local RECOMMENDATION_SESSION_ID_KEY = require(PYMKCarousel.Common.Constants).RECOMMENDATION_SESSION_ID_KEY
local PYMKCollectionCarousel = require(PYMKCarousel.Components.PYMKCollectionCarousel)

require(PYMKCarousel.Analytics.AnalyticsTypes)

local function PYMKCarouselEntryPoint(t1: {[any]: any}) -- line: 43
	-- upvalues: useLocalUserId (copy), useSelector (copy), getSessionIdByKey (copy), RECOMMENDATION_SESSION_ID_KEY (copy), React (copy), setupFireEvent (copy), PYMKCollectionCarousel (copy)
	local v14 = useLocalUserId()
	local v15 = useSelector(function(p1) -- line: 46
		-- upvalues: getSessionIdByKey (copy), RECOMMENDATION_SESSION_ID_KEY (copy)
		return getSessionIdByKey(p1)(RECOMMENDATION_SESSION_ID_KEY)
	end)
	local v16 = React.useMemo(function() -- line: 50
		-- upvalues: setupFireEvent (copy), v14 (copy), v15 (copy), t1 (copy)
		return setupFireEvent({
			infoForAllEvents = {
				rowNumber = 1,
				uid = v14,
				recommendationSessionId = v15,
				sortIndex = t1.sortAnalyticsData.sortIndex,
				sortId = t1.sortAnalyticsData.sortId,
				appPage = t1.sortAnalyticsData.appPage,
				feedRowNumber = t1.sortAnalyticsData.startRow
			},
			analytics = {
				Diag = t1.diagService,
				EventStream = t1.eventIngestService
			}
		})
	end, {
		v14,
		v15,
		t1.sortAnalyticsData
	})

	if not v14 then
		return nil
	end

	if v15 or t1.findFriendsTileEnabled then
		return React.createElement(PYMKCollectionCarousel, {
			findFriendsTileEnabled = t1.findFriendsTileEnabled,
			seeAllTileEnabled = t1.seeAllTileEnabled,
			recommendationSessionId = v15,
			carouselTitle = t1.carouselTitle,
			sideMargin = t1.sideMargin,
			openProfilePeekView = t1.openProfilePeekView,
			showToast = t1.showToast,
			goToAddFriendsPage = t1.goToAddFriendsPage,
			shouldShowContactImporterBadge = t1.shouldShowContactImporterBadge,
			pageContext = t1.pageContext,
			scrollViewPositionChangedSignal = t1.scrollViewPositionChangedSignal,
			fireAnalyticsEvent = v16,
			appCompositionEnabled = t1.appCompositionEnabled
		})
	end

	return nil
end

return PYMKCarouselEntryPoint
