local SocialCarousel = script:FindFirstAncestor("SocialCarousel")
local parent = SocialCarousel.Parent
local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)

local RoactServiceTags = require(parent.RoactServiceTags)
local AppEventIngestService = RoactServiceTags.AppEventIngestService
local RoactServiceTags2 = require(parent.RoactServiceTags)
local RoactAnalytics = RoactServiceTags2.RoactAnalytics
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useRoactService = RobloxAppHooks.useRoactService
local useThrottledCallback = RoactUtils.Hooks.useThrottledCallback

require(SocialCarousel.Common.Enums)

local SocialCarouselContext = require(SocialCarousel.Contexts.SocialCarouselContext)
local useSocialCarouselList = require(SocialCarousel.Hooks.useSocialCarouselList)
local useSocialCarouselUnifiedLogging = require(SocialCarousel.Analytics.useSocialCarouselUnifiedLogging)
local useSocialCarouselAnalytics = require(SocialCarousel.Analytics.useSocialCarouselAnalytics)
local useSocialCarouselLoadTimer = require(SocialCarousel.Analytics.useSocialCarouselLoadTimer)

require(SocialCarousel.Analytics.AnalyticsTypes)

local defineFastInt = game:DefineFastInt("FriendCarouselRefreshThrottleInterval", 3)
local SharedFlags = require(parent.SharedFlags)
local FFlagSocialCarouselShareQREnabled = SharedFlags.FFlagSocialCarouselShareQREnabled
local SharedFlags2 = require(parent.SharedFlags)
local FFlagMobileGameJoinCardVideo = SharedFlags2.FFlagMobileGameJoinCardVideo
local SharedFlags3 = require(parent.SharedFlags)
local FFlagSocialCarouselBuildPresence = SharedFlags3.FFlagSocialCarouselBuildPresence
local SharedFlags4 = require(parent.SharedFlags)
local FFlagSocialCarouselInGameTitleMarquee = SharedFlags4.FFlagSocialCarouselInGameTitleMarquee

local Carousel = require(SocialCarousel.Components.Carousel)

return function(props)
	local appAnalytics = useRoactService(RoactAnalytics)
	local eventIngest = useRoactService(AppEventIngestService)
	local v = useSocialCarouselLoadTimer(useSocialCarouselAnalytics().reportLoadingEvent)
	local ref = React.useRef(os.clock())
	local v2 = useSocialCarouselList(props.roduxKey, props.customTileList)

	local state, setState = React.useState(nil)
	local state2, setState2

	if FFlagSocialCarouselBuildPresence then
		state2, setState2 = React.useState(nil)
	end

	local ref2 = React.useRef(nil)
	local ref3

	if FFlagSocialCarouselInGameTitleMarquee then
		ref3 = React.useRef(nil)
	end

	local setOpenGameJoinCardUserId = React.useCallback(function(current)
		if typeof(current) == "function" then
			current = current(ref2.current)
		end

		ref2.current = current
		setState(current)
	end, { setState })
	local unifiedLogging = useSocialCarouselUnifiedLogging(appAnalytics, eventIngest, props.unifiedLogging, v2, ref)

	local v3 = useThrottledCallback(function()
		v2.refreshFriendsList()
	end, defineFastInt)

	React.useEffect(function()
		if not props.refreshSignal then
			return
		end

		props.refreshSignal:connect(v3)
	end, { props.refreshSignal })

	local createElement = React.createElement
	local provider = SocialCarouselContext.Provider
	local v4 = {
		eventIngest = eventIngest,
		appAnalytics = appAnalytics,
		hideCarouselHeader = props.hideCarouselHeader,
		openGameJoinCardUserId = state,
		joinPopoverUserIdRef = 0,
		joinSheetUserIdRef = 0,
		setOpenGameJoinCardUserId = 0,
		openBuildCardUserId = 0,
		setOpenBuildCardUserId = 0,
		unifiedLogging = 0,
		sortAnalyticsData = 0,
		friendRequestCount = 0,
		recommendationCount = 0,
		friendCount = 0,
		tiles = 0,
		isLoading = 0,
		onSuccessfulRender = 0,
		selectionOrderBase = 0,
		source = 0,
		navigateToQRCodePage = 0,
		isJoinCardVideoEnabled = 0,
		videoPlaybackContext = 0
	}
	local joinPopoverUserIdRef

	if FFlagSocialCarouselInGameTitleMarquee then
		joinPopoverUserIdRef = ref2
	end

	v4.joinPopoverUserIdRef = joinPopoverUserIdRef

	if not FFlagSocialCarouselInGameTitleMarquee then
		ref3 = nil
	end

	v4.joinSheetUserIdRef = ref3

	if not FFlagSocialCarouselInGameTitleMarquee then
		setOpenGameJoinCardUserId = setState
	end

	v4.setOpenGameJoinCardUserId = setOpenGameJoinCardUserId

	if not FFlagSocialCarouselBuildPresence then
		state2 = nil
	end

	v4.openBuildCardUserId = state2

	if not FFlagSocialCarouselBuildPresence then
		setState2 = nil
	end

	v4.setOpenBuildCardUserId = setState2
	v4.unifiedLogging = unifiedLogging
	v4.sortAnalyticsData = props.sortAnalyticsData
	v4.friendRequestCount = v2.friendRequestCount
	v4.recommendationCount = v2.recommendationCount
	v4.friendCount = v2.friendCount
	v4.tiles = v2.tiles
	v4.isLoading = v2.isLoading
	v4.onSuccessfulRender = v.onSuccessfulRender
	v4.selectionOrderBase = props.selectionOrderBase
	v4.source = props.source
	local navigateToQRCodePage

	if FFlagSocialCarouselShareQREnabled then
		navigateToQRCodePage = props.navigateToQRCodePage
	end

	v4.navigateToQRCodePage = navigateToQRCodePage
	local isJoinCardVideoEnabled

	if FFlagMobileGameJoinCardVideo then
		isJoinCardVideoEnabled = props.isJoinCardVideoEnabled
	end

	v4.isJoinCardVideoEnabled = isJoinCardVideoEnabled
	local videoPlaybackContext

	if FFlagMobileGameJoinCardVideo then
		videoPlaybackContext = props.videoPlaybackContext
	end

	v4.videoPlaybackContext = videoPlaybackContext
	return createElement(provider, { value = v4 }, {
		Carousel = React.createElement(Carousel, {
			appCompositionEnabled = props.appCompositionEnabled
		})
	})
end
