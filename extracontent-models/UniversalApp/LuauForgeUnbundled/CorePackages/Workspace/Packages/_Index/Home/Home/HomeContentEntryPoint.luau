local AppLifecycleObserverService = game:GetService("AppLifecycleObserverService")
local ExperienceService = game:GetService("ExperienceService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Home/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/Home/SignalsReact")
local useSponsoredAdViewabilityDetector = require("@game/CorePackages/Workspace/Packages/_Workspace/Home/SponsoredAdViewability").useSponsoredAdViewabilityDetector
require("@game/CorePackages/Workspace/Packages/_Workspace/Home/Navigation")
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/Home/RobloxAppEnums").AppPage
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/Home/Responsive")
local SduiSharedUtilities = require("@game/CorePackages/Workspace/Packages/_Workspace/Home/SduiSharedUtilities")
local sduiPageWrapperEntryPoint = SduiSharedUtilities.SduiPageWrapperEntryPoint
local usePageScopeRef = SduiSharedUtilities.usePageScopeRef
local useEntrySurfacing = SduiSharedUtilities.useEntrySurfacing
local VideoUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/Home/VideoUtils")

local refreshHomePage = require("@game/CorePackages/Workspace/Packages/_Index/Home/Home/refreshHomePage")
local fetchHomePage = require("@game/CorePackages/Workspace/Packages/_Index/Home/Home/fetchHomePage")
local useHomeCollectionLayoutSync = require("@game/CorePackages/Workspace/Packages/_Index/Home/Home/useHomeCollectionLayoutSync")
local HomeConstants = require("@game/CorePackages/Workspace/Packages/_Index/Home/Home/HomeConstants")
local HomePageSession = require("@game/CorePackages/Workspace/Packages/_Index/Home/Home/HomePageSession")
local fFlagLuaAppAddHomeExtraTopPadding = require("@game/CorePackages/Workspace/Packages/_Workspace/Home/SharedFlags").FFlagLuaAppAddHomeExtraTopPadding
local fFlagLuaAppSduiVideoThumbnail = require("@game/CorePackages/Workspace/Packages/_Workspace/Home/SharedFlags").FFlagLuaAppSduiVideoThumbnail
local fFlagLuaAppOneByTwoHoverIdleAutoplay = require("@game/CorePackages/Workspace/Packages/_Workspace/Home/SharedFlags").FFlagLuaAppOneByTwoHoverIdleAutoplay

local fFlagLuaAppSduiSuppressVideoDetectorDuringScroll = require("@game/CorePackages/Workspace/Packages/_Workspace/Home/SharedFlags").FFlagLuaAppSduiSuppressVideoDetectorDuringScroll
local fFlagSduiDismissPromptPageScope = require("@game/CorePackages/Workspace/Packages/_Workspace/Home/SharedFlags").FFlagSduiDismissPromptPageScope
local fFlagAppPageShellScrollToTopFocus = require("@game/CorePackages/Workspace/Packages/_Workspace/Home/SharedFlags").FFlagAppPageShellScrollToTopFocus

local fFlagHomePageRefetchOnDataHydrationAccountReset = require("@game/CorePackages/Workspace/Packages/_Workspace/Home/SharedFlags").FFlagHomePageRefetchOnDataHydrationAccountReset
local FFlagLuaAppSduiHomeSponsoredAdViewability = require("@game/CorePackages/Workspace/Packages/_Index/Home/Home/Flags/FFlagLuaAppSduiHomeSponsoredAdViewability")
local fFlagAppThemeHalloween2026HomeBackground = require("@game/CorePackages/Workspace/Packages/_Workspace/Home/SharedFlags").FFlagAppThemeHalloween2026HomeBackground

local function getFromPropsOrNavigationParams(p2, p3)
	return p2[p3] or p2.navigation and p2.navigation.getParam(p3)
end

local function getCommittedHomeSessionId(p2)
	local v5 = HomePageSession:GetCommittedSignal()(p2)

	if v5 then
		return v5.sessionId
	end

	return nil
end

local function HomeContentEntryPoint(props)
	local configKey = HomeConstants.ConfigKey
	local v5

	if fFlagLuaAppAddHomeExtraTopPadding then
		local v6 = useEntrySurfacing(configKey, HomeConstants.ContentIdentifier, "fullPage")
		local contentTopPadding = v6 and v6.contentTopPadding or 0
		v5 = (props.feedTopMargin or 0) + contentTopPadding
	end

	if fFlagSduiDismissPromptPageScope then
		usePageScopeRef(configKey)
	end

	local pageTimer = props.pageTimer or props.navigation and props.navigation.getParam("pageTimer")

	local v6 = React.useMemo(function()
		return pageTimer or SduiSharedUtilities.SduiLoadTimer.createLoadTimer(appPage.Home)
	end, { configKey, pageTimer })
	local v7

	if fFlagHomePageRefetchOnDataHydrationAccountReset then
		v7 = SduiSharedUtilities.useDataHydrationAccountGeneration()
	end

	local useEffect = React.useEffect
	local function fn()
		fetchHomePage(v6)
	end

	if not fFlagHomePageRefetchOnDataHydrationAccountReset then
		v7 = nil
	end

	useEffect(fn, { configKey, v6, v7 })

	React.useEffect(function()
		return require("@game/CorePackages/Workspace/Packages/_Index/Home/Home/getHomePageAutoRefreshStore")(false).start()
	end, {})

	useHomeCollectionLayoutSync()

	local v9 = nil

	if fFlagLuaAppOneByTwoHoverIdleAutoplay then
		local v10 = Responsive.usePreferredInput()
		local v11 = v10 == Responsive.Input.Pointer

		local playbackDetectionMethod = VideoUtils.getPlaybackDetectionMethod(v10, v11)

		v9 = VideoUtils.useFeedVideoPlaybackContext(nil, nil, nil, nil, playbackDetectionMethod)
	elseif fFlagLuaAppSduiVideoThumbnail then
		local v10 = Responsive.usePreferredInput() == Responsive.Input.Touch

		v9 = React.useMemo(function()
			return VideoUtils.FeedVideoPlaybackContext.new(v10)
		end, { v10 })
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
	end

	if fFlagLuaAppSduiSuppressVideoDetectorDuringScroll then
		local v10 = Responsive.usePreferredInput() == Responsive.Input.Touch

		local viewportVideoAutoplayController = if v9 then v9.viewportVideoAutoplayController else nil

		React.useEffect(function()
			if not viewportVideoAutoplayController then
				return nil
			end

			viewportVideoAutoplayController:setSuppressDetectorsDuringScroll(v10)

			if not v10 then
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
		end, { viewportVideoAutoplayController, v10 })
	end

	local createElement = React.createElement

	if not FFlagLuaAppSduiHomeSponsoredAdViewability then
		setState = nil
	end

	local v11 = {
		ref = setState,
		appPage = appPage.Home,
		configKey = configKey,
		contentIdentifier = HomeConstants.ContentIdentifier,
		pageTimer = v6,
		refresh = refreshHomePage,
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

	if not fFlagLuaAppAddHomeExtraTopPadding then
		v5 = props.feedTopMargin
	end

	v11.feedTopMargin = v5
	v11.stickyTopPadding = props.feedTopMargin
	v11.scrollAway = props.scrollAway

	if not (fFlagLuaAppSduiVideoThumbnail or fFlagLuaAppOneByTwoHoverIdleAutoplay) then
		v9 = nil
	end

	v11.videoPlaybackContext = v9

	v11.handleBackButton = if fFlagAppPageShellScrollToTopFocus then false else nil
	local v13 = if fFlagAppPageShellScrollToTopFocus then props.defaultFocusRef else nil
	v11.defaultFocusRef = v13
	local v14 = if fFlagAppThemeHalloween2026HomeBackground then props.backgroundStyle else nil
	v11.backgroundStyle = v14
	local v15 = if fFlagAppThemeHalloween2026HomeBackground then props.stickyBackgroundStyle else nil
	v11.stickyBackgroundStyle = v15
	return createElement(sduiPageWrapperEntryPoint, v11)
end

return React.memo(HomeContentEntryPoint)
