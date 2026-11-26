local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/React")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/RoactUtils")

local appEventIngestService = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/RoactServiceTags").AppEventIngestService
local roactAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/RoactServiceTags").RoactAnalytics
local useRoactService = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/RobloxAppHooks").useRoactService
local useThrottledCallback = RoactUtils.Hooks.useThrottledCallback

require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Common/Enums")

local SocialCarouselContext = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Contexts/SocialCarouselContext")
local useSocialCarouselList = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Hooks/useSocialCarouselList")
local useSocialCarouselUnifiedLogging = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Analytics/useSocialCarouselUnifiedLogging")
local useSocialCarouselAnalytics = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Analytics/useSocialCarouselAnalytics")
local useSocialCarouselLoadTimer = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Analytics/useSocialCarouselLoadTimer")

require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Analytics/AnalyticsTypes")

local defineFastInt = game:DefineFastInt("FriendCarouselRefreshThrottleInterval", 3)
local fFlagSocialCarouselShareQREnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/SharedFlags").FFlagSocialCarouselShareQREnabled
local fFlagMobileGameJoinCardVideo = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/SharedFlags").FFlagMobileGameJoinCardVideo
local fFlagSocialCarouselBuildPresence = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/SharedFlags").FFlagSocialCarouselBuildPresence
local fFlagSocialCarouselInGameTitleMarquee = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/SharedFlags").FFlagSocialCarouselInGameTitleMarquee

local module8 = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Components/Carousel")

return function(props)
	local v5 = useRoactService(roactAnalytics)
	local v6 = useRoactService(appEventIngestService)
	local v8 = useSocialCarouselLoadTimer(useSocialCarouselAnalytics().reportLoadingEvent)
	local ref = React.useRef(os.clock())
	local v9 = useSocialCarouselList(props.roduxKey, props.customTileList)

	local state, setState = React.useState(nil)
	local state2, setState2

	if fFlagSocialCarouselBuildPresence then
		state2, setState2 = React.useState(nil)
	end

	local ref2 = React.useRef(nil)

	local ref3 = if fFlagSocialCarouselInGameTitleMarquee then React.useRef(nil) else nil

	local v11 = React.useCallback(function(current)
		if typeof(current) == "function" then
			current = current(ref2.current)
		end

		ref2.current = current
		setState(current)
	end, { setState })
	local v12 = useSocialCarouselUnifiedLogging(v5, v6, props.unifiedLogging, v9, ref)

	local v13 = useThrottledCallback(function()
		v9.refreshFriendsList()
	end, defineFastInt)

	React.useEffect(function()
		if not props.refreshSignal then
			return
		end

		props.refreshSignal:connect(v13)
	end, { props.refreshSignal })

	local createElement = React.createElement
	local provider = SocialCarouselContext.Provider
	local v15 = {
		eventIngest = v6,
		appAnalytics = v5,
		hideCarouselHeader = props.hideCarouselHeader,
		openGameJoinCardUserId = state,
		joinPopoverUserIdRef = if fFlagSocialCarouselInGameTitleMarquee then ref2 else nil,
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

	if not fFlagSocialCarouselInGameTitleMarquee then
		ref3 = nil
	end

	v15.joinSheetUserIdRef = ref3

	if not fFlagSocialCarouselInGameTitleMarquee then
		v11 = setState
	end

	v15.setOpenGameJoinCardUserId = v11

	if not fFlagSocialCarouselBuildPresence then
		state2 = nil
	end

	v15.openBuildCardUserId = state2

	if not fFlagSocialCarouselBuildPresence then
		setState2 = nil
	end

	v15.setOpenBuildCardUserId = setState2
	v15.unifiedLogging = v12
	v15.sortAnalyticsData = props.sortAnalyticsData
	v15.friendRequestCount = v9.friendRequestCount
	v15.recommendationCount = v9.recommendationCount
	v15.friendCount = v9.friendCount
	v15.tiles = v9.tiles
	v15.isLoading = v9.isLoading
	v15.onSuccessfulRender = v8.onSuccessfulRender
	v15.selectionOrderBase = props.selectionOrderBase
	v15.source = props.source
	local v17 = if fFlagSocialCarouselShareQREnabled then props.navigateToQRCodePage else nil
	v15.navigateToQRCodePage = v17
	local v18 = if fFlagMobileGameJoinCardVideo then props.isJoinCardVideoEnabled else nil
	v15.isJoinCardVideoEnabled = v18
	local v19 = if fFlagMobileGameJoinCardVideo then props.videoPlaybackContext else nil
	v15.videoPlaybackContext = v19
	return createElement(provider, { value = v15 }, {
		Carousel = React.createElement(module8, {
			appCompositionEnabled = props.appCompositionEnabled
		})
	})
end
