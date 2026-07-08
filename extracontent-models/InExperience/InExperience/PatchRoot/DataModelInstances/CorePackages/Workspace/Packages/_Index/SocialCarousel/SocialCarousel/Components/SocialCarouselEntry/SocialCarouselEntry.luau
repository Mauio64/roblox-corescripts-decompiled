local SocialCarousel = script:FindFirstAncestor("SocialCarousel")
local SocialCarouselParent = SocialCarousel.Parent
local React = require(SocialCarouselParent.React)
local RoactUtils = require(SocialCarouselParent.RoactUtils)
local AppEventIngestService = require(SocialCarouselParent.RoactServiceTags).AppEventIngestService
local RoactAnalytics = require(SocialCarouselParent.RoactServiceTags).RoactAnalytics
local useRoactService = require(SocialCarouselParent.RobloxAppHooks).useRoactService
local useThrottledCallback = RoactUtils.Hooks.useThrottledCallback

require(SocialCarousel.Common.Enums)

local SocialCarouselContext = require(SocialCarousel.Contexts.SocialCarouselContext)
local useSocialCarouselList = require(SocialCarousel.Hooks.useSocialCarouselList)
local useSocialCarouselUnifiedLogging = require(SocialCarousel.Analytics.useSocialCarouselUnifiedLogging)
local useSocialCarouselAnalytics = require(SocialCarousel.Analytics.useSocialCarouselAnalytics)
local useSocialCarouselLoadTimer = require(SocialCarousel.Analytics.useSocialCarouselLoadTimer)

require(SocialCarousel.Analytics.AnalyticsTypes)

local v14 = game:DefineFastInt("FriendCarouselRefreshThrottleInterval", 3)
local FFlagLuaAppAddSortDataToSocialCarouselClicks = require(SocialCarouselParent.SharedFlags).FFlagLuaAppAddSortDataToSocialCarouselClicks
local FFlagSocialCarouselShareQREnabled = require(SocialCarouselParent.SharedFlags).FFlagSocialCarouselShareQREnabled
local FFlagEnableDesktopGameJoinCard = require(SocialCarouselParent.SharedFlags).FFlagEnableDesktopGameJoinCard
local Carousel = require(SocialCarousel.Components.Carousel)

return function(t1: {[any]: any}) -- line: 54
	-- upvalues: useRoactService (copy), RoactAnalytics (copy), AppEventIngestService (copy), useSocialCarouselAnalytics (copy), useSocialCarouselLoadTimer (copy), React (copy), useSocialCarouselList (copy), FFlagEnableDesktopGameJoinCard (copy), useSocialCarouselUnifiedLogging (copy), useThrottledCallback (copy), v14 (copy), SocialCarouselContext (copy), FFlagLuaAppAddSortDataToSocialCarouselClicks (copy), FFlagSocialCarouselShareQREnabled (copy), Carousel (copy)
	local v20 = useRoactService(RoactAnalytics)
	local v21 = useRoactService(AppEventIngestService)
	local v22 = useSocialCarouselAnalytics()
	local v23 = useSocialCarouselLoadTimer(v22.reportLoadingEvent)
	local v24 = React.useRef(os.clock())
	local v25 = useSocialCarouselList(t1.roduxKey, t1.customTileList)
	local v26 = nil
	local v27 = nil

	if FFlagEnableDesktopGameJoinCard then
		v26, v27 = React.useState(nil)
	end

	local v28 = useSocialCarouselUnifiedLogging(v20, v21, t1.unifiedLogging, v25, v24)
	local v29 = useThrottledCallback(function() -- line: 73
		-- upvalues: v25 (copy)
		v25.refreshFriendsList()
	end, v14)

	React.useEffect(function() -- line: 77
		-- upvalues: t1 (copy), v29 (copy)
		if not t1.refreshSignal then
			return
		end

		t1.refreshSignal:connect(v29)
	end, { t1.refreshSignal })

	return React.createElement(SocialCarouselContext.Provider, {
		value = {
			eventIngest = v21,
			appAnalytics = v20,
			hideCarouselHeader = t1.hideCarouselHeader,
			openGameJoinCardUserId = if not FFlagEnableDesktopGameJoinCard then nil else v26,
			setOpenGameJoinCardUserId = if not FFlagEnableDesktopGameJoinCard then nil else v27,
			unifiedLogging = v28,
			sortAnalyticsData = if not FFlagLuaAppAddSortDataToSocialCarouselClicks then nil else t1.sortAnalyticsData,
			friendRequestCount = v25.friendRequestCount,
			recommendationCount = v25.recommendationCount,
			friendCount = v25.friendCount,
			tiles = v25.tiles,
			isLoading = v25.isLoading,
			onSuccessfulRender = v23.onSuccessfulRender,
			selectionOrderBase = t1.selectionOrderBase,
			source = t1.source,
			navigateToQRCodePage = if not FFlagSocialCarouselShareQREnabled then nil else t1.navigateToQRCodePage
		}
	}, {
		Carousel = React.createElement(Carousel, {
			appCompositionEnabled = t1.appCompositionEnabled
		})
	})
end
