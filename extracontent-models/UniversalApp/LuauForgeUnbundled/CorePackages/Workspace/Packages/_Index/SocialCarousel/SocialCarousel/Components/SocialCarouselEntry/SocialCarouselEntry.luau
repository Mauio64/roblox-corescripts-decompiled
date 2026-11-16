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
local fFlagSocialCarouselBuildPresence = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/SharedFlags").FFlagSocialCarouselBuildPresence

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

	local v10 = useSocialCarouselUnifiedLogging(v5, v6, props.unifiedLogging, v9, ref)

	local v11 = useThrottledCallback(function()
		v9.refreshFriendsList()
	end, defineFastInt)

	React.useEffect(function()
		if not props.refreshSignal then
			return
		end

		props.refreshSignal:connect(v11)
	end, { props.refreshSignal })

	local createElement = React.createElement
	local provider = SocialCarouselContext.Provider
	local v13 = {
		eventIngest = v6,
		appAnalytics = v5,
		hideCarouselHeader = props.hideCarouselHeader,
		openGameJoinCardUserId = state,
		setOpenGameJoinCardUserId = setState,
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
		navigateToQRCodePage = 0
	}

	if not fFlagSocialCarouselBuildPresence then
		state2 = nil
	end

	v13.openBuildCardUserId = state2

	if not fFlagSocialCarouselBuildPresence then
		setState2 = nil
	end

	v13.setOpenBuildCardUserId = setState2
	v13.unifiedLogging = v10
	v13.sortAnalyticsData = props.sortAnalyticsData
	v13.friendRequestCount = v9.friendRequestCount
	v13.recommendationCount = v9.recommendationCount
	v13.friendCount = v9.friendCount
	v13.tiles = v9.tiles
	v13.isLoading = v9.isLoading
	v13.onSuccessfulRender = v8.onSuccessfulRender
	v13.selectionOrderBase = props.selectionOrderBase
	v13.source = props.source
	local v14 = if fFlagSocialCarouselShareQREnabled then props.navigateToQRCodePage else nil
	v13.navigateToQRCodePage = v14
	return createElement(provider, { value = v13 }, {
		Carousel = React.createElement(module8, {
			appCompositionEnabled = props.appCompositionEnabled
		})
	})
end
