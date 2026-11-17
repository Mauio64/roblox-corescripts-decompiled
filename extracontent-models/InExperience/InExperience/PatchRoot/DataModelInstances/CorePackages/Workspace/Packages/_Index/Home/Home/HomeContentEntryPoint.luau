local AppLifecycleObserverService = game:GetService("AppLifecycleObserverService")
local ExperienceService = game:GetService("ExperienceService")

local Home = script:FindFirstAncestor("Home")
local parent = Home.Parent

local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)
local SponsoredAdViewability = require(parent.SponsoredAdViewability)
local useSponsoredAdViewabilityDetector = SponsoredAdViewability.useSponsoredAdViewabilityDetector
require(parent.Navigation)
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local Responsive = require(parent.Responsive)
local SduiSharedUtilities = require(parent.SduiSharedUtilities)
local SduiPageWrapperEntryPoint = SduiSharedUtilities.SduiPageWrapperEntryPoint
local usePageScopeRef = SduiSharedUtilities.usePageScopeRef
local useEntrySurfacing = SduiSharedUtilities.useEntrySurfacing
local VideoUtils = require(parent.VideoUtils)

local refreshHomePage = require(Home.refreshHomePage)
local fetchHomePage = require(Home.fetchHomePage)
local useHomeCollectionLayoutSync = require(Home.useHomeCollectionLayoutSync)
local useHomeStartupSnapshot = require(Home.useHomeStartupSnapshot)
local HomeConstants = require(Home.HomeConstants)
local HomePageSession = require(Home.HomePageSession)
local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppAddHomeExtraTopPadding = SharedFlags.FFlagLuaAppAddHomeExtraTopPadding
local SharedFlags2 = require(parent.SharedFlags)
local FFlagLuaAppSduiVideoThumbnail = SharedFlags2.FFlagLuaAppSduiVideoThumbnail
local SharedFlags3 = require(parent.SharedFlags)
local FFlagLuaAppOneByTwoHoverIdleAutoplay = SharedFlags3.FFlagLuaAppOneByTwoHoverIdleAutoplay

local SharedFlags4 = require(parent.SharedFlags)
local FFlagLuaAppSduiSuppressVideoDetectorDuringScroll = SharedFlags4.FFlagLuaAppSduiSuppressVideoDetectorDuringScroll
local SharedFlags5 = require(parent.SharedFlags)
local FFlagSduiDismissPromptPageScope = SharedFlags5.FFlagSduiDismissPromptPageScope
local SharedFlags6 = require(parent.SharedFlags)
local FFlagAppPageShellScrollToTopFocus = SharedFlags6.FFlagAppPageShellScrollToTopFocus
local SharedFlags7 = require(parent.SharedFlags)
local FFlagAppPageShellScrollTelemetry = SharedFlags7.FFlagAppPageShellScrollTelemetry

local SharedFlags8 = require(parent.SharedFlags)
local FFlagHomePageRefetchOnDataHydrationAccountReset = SharedFlags8.FFlagHomePageRefetchOnDataHydrationAccountReset
local FFlagLuaAppSduiHomeSponsoredAdViewability = require(Home.Flags.FFlagLuaAppSduiHomeSponsoredAdViewability)
local SharedFlags9 = require(parent.SharedFlags)
local FFlagAppThemeHalloween2026HomeBackground = SharedFlags9.FFlagAppThemeHalloween2026HomeBackground
local SharedFlags10 = require(parent.SharedFlags)
local FFlagSduiHomeStartupSnapshot = SharedFlags10.FFlagSduiHomeStartupSnapshot

local function getFromPropsOrNavigationParams(props, p: string) -- 1 equivalent call inferred from this helper
	return props[p] or props.navigation and props.navigation.getParam(p)
end

local function getCommittedHomeSessionId(p)
	local v = HomePageSession:GetCommittedSignal()(p)
	return if v then v.sessionId else nil
end

local function HomeContentEntryPoint(props)
	local configKey = HomeConstants.ConfigKey
	local feedTopMargin

	if FFlagLuaAppAddHomeExtraTopPadding then
		local v = useEntrySurfacing(configKey, HomeConstants.ContentIdentifier, "fullPage")
		local contentTopPadding = v and v.contentTopPadding or 0
		feedTopMargin = (props.feedTopMargin or 0) + contentTopPadding
	end

	if FFlagSduiDismissPromptPageScope then
		usePageScopeRef(configKey)
	end

	local v = getFromPropsOrNavigationParams(props, "pageTimer") -- inferred equivalent call
	local pageTimer = React.useMemo(function()
		return v or SduiSharedUtilities.SduiLoadTimer.createLoadTimer(AppPage.Home)
	end, { configKey, v })
	local v2

	if FFlagHomePageRefetchOnDataHydrationAccountReset then
		v2 = SduiSharedUtilities.useDataHydrationAccountGeneration()
	end

	local useEffect = React.useEffect
	local function fn()
		fetchHomePage(pageTimer)
	end

	if not FFlagHomePageRefetchOnDataHydrationAccountReset then
		v2 = nil
	end

	useEffect(fn, { configKey, pageTimer, v2 })

	React.useEffect(function()
		local getHomePageAutoRefreshStore = require(Home.getHomePageAutoRefreshStore)
		return getHomePageAutoRefreshStore(false).start()
	end, {})

	useHomeCollectionLayoutSync()

	local videoPlaybackContext = nil

	if FFlagLuaAppOneByTwoHoverIdleAutoplay then
		local v3 = Responsive.usePreferredInput()
		local v4 = v3 == Responsive.Input.Pointer

		local playbackDetectionMethod = VideoUtils.getPlaybackDetectionMethod(v3, v4)

		videoPlaybackContext = VideoUtils.useFeedVideoPlaybackContext(nil, nil, nil, nil, playbackDetectionMethod)
	elseif FFlagLuaAppSduiVideoThumbnail then
		local v3 = Responsive.usePreferredInput() == Responsive.Input.Touch

		videoPlaybackContext = React.useMemo(function()
			return VideoUtils.FeedVideoPlaybackContext.new(v3)
		end, { v3 })
	end

	local setState

	if FFlagLuaAppSduiHomeSponsoredAdViewability then
		local state
		state, setState = React.useState(nil)
		useSponsoredAdViewabilityDetector(
			state,
			SignalsReact.useSignalState(getCommittedHomeSessionId),
			AppLifecycleObserverService
		)
	else
		setState = nil
	end

	local ref

	if FFlagSduiHomeStartupSnapshot then
		local state, setState2 = React.useState(nil)

		useHomeStartupSnapshot(state, props.navigation)
		ref = React.useCallback(function(p)
			setState2(p)

			if setState then
				setState(p)
			end
		end, { setState })
	end

	if FFlagLuaAppSduiSuppressVideoDetectorDuringScroll then
		local v3 = Responsive.usePreferredInput() == Responsive.Input.Touch
		local viewportVideoAutoplayController

		if videoPlaybackContext then
			viewportVideoAutoplayController = videoPlaybackContext.viewportVideoAutoplayController
		else
			viewportVideoAutoplayController = nil
		end

		React.useEffect(function()
			if not viewportVideoAutoplayController then
				return nil
			end

			viewportVideoAutoplayController:setSuppressDetectorsDuringScroll(v3)

			if not v3 then
				return nil
			end

			local onHideConnection = AppLifecycleObserverService.OnHide:Connect(function()
				viewportVideoAutoplayController:reset(VideoUtils.AnalyticsEnums.VideoEndReason.AppBackgrounded)
			end)
			local connection = ExperienceService:RegisterForExperienceJoin(function()
				viewportVideoAutoplayController:reset(VideoUtils.AnalyticsEnums.VideoEndReason.ExperienceLaunched)
			end)

			return function()
				onHideConnection:Disconnect()
				connection:Disconnect()
			end
		end, { viewportVideoAutoplayController, v3 })
	end

	local createElement = React.createElement

	if not FFlagSduiHomeStartupSnapshot then
		if FFlagLuaAppSduiHomeSponsoredAdViewability then
			ref = setState
		else
			ref = nil
		end
	end

	local v3 = {
		ref = ref,
		appPage = AppPage.Home,
		configKey = configKey,
		contentIdentifier = HomeConstants.ContentIdentifier,
		pageTimer = pageTimer,
		refresh = refreshHomePage,
		scrollPerformanceIntervalName = FFlagAppPageShellScrollTelemetry and "LuaApp_Home_Scroll" or nil,
		pageTopPadding = props.pageTopPadding,
		feedTopMargin = 0,
		stickyTopPadding = 0,
		scrollAway = 0,
		videoPlaybackContext = 0,
		handleBackButton = 0,
		defaultFocusRef = 0,
		backgroundStyle = 0,
		stickyBackgroundStyle = 0
	}

	if not FFlagLuaAppAddHomeExtraTopPadding then
		feedTopMargin = props.feedTopMargin
	end

	v3.feedTopMargin = feedTopMargin
	v3.stickyTopPadding = props.feedTopMargin
	v3.scrollAway = props.scrollAway

	if not (FFlagLuaAppSduiVideoThumbnail or FFlagLuaAppOneByTwoHoverIdleAutoplay) then
		videoPlaybackContext = nil
	end

	v3.videoPlaybackContext = videoPlaybackContext

	v3.handleBackButton = not FFlagAppPageShellScrollToTopFocus and nil
	local defaultFocusRef

	if FFlagAppPageShellScrollToTopFocus then
		defaultFocusRef = props.defaultFocusRef
	end

	v3.defaultFocusRef = defaultFocusRef
	local backgroundStyle

	if FFlagAppThemeHalloween2026HomeBackground then
		backgroundStyle = props.backgroundStyle
	end

	v3.backgroundStyle = backgroundStyle
	local stickyBackgroundStyle

	if FFlagAppThemeHalloween2026HomeBackground then
		stickyBackgroundStyle = props.stickyBackgroundStyle
	end

	v3.stickyBackgroundStyle = stickyBackgroundStyle
	return createElement(SduiPageWrapperEntryPoint, v3)
end

return React.memo(HomeContentEntryPoint)
