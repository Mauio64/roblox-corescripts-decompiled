local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/RobloxAppEnums").AppPage
local RobloxAppEvents = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/RobloxAppEvents")
local RoactNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/RoactNavigation")

local view = Foundation.View

local TopBar = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/TopBar")
local MomentsFeedSurface = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/MomentsFeedSurface")
local module7 = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed")

local creationFlowScreen = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/MomentsCreation").CreationFlowScreen
local FTUXEducationScreen = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/FTUXEducationScreen")
local useMomentsHost = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/MomentsHostContext").useMomentsHost
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Constants")
local useScreenBottomInset = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Hooks/useScreenBottomInset")
local useFeedPlaybackActive = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Hooks/useFeedPlaybackActive")
local useMomentsTabIsVisible = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Hooks/useMomentsTabIsVisible")
local GetMomentsPreferencesStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetMomentsPreferencesStore")
local NavigationDestinationType = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Enums/NavigationDestinationType")
local FFlagMomentsNavigationEvent = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsNavigationEvent")

local FFlagMomentsFixRecommendationImpressionLifecycle = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsFixRecommendationImpressionLifecycle")
local FFlagMomentsFlushDwellBeforeNavigation = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsFlushDwellBeforeNavigation")

local FFlagMomentsPersonalizedRecommendationsEntryPoint = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsPersonalizedRecommendationsEntryPoint")
local useCreationEntry = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Hooks/useCreationEntry")
local useUploadHost = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Hooks/useUploadHost")
local logCreateIntent = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Analytics/logCreateIntent")
local GetUploadStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetUploadStore")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SignalsReact")
local MomentOverlayInsetContext = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/Moment/MomentOverlayInsetContext")
local FFlagMomentsFeedAboveNavBar = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsFeedAboveNavBar")
local FFlagMomentsFixFeedForDeviceSafeInsets = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsFixFeedForDeviceSafeInsets")
local shouldUseDeviceSafeInsets = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Display").shouldUseDeviceSafeInsets
local v5 = FFlagMomentsFixFeedForDeviceSafeInsets and shouldUseDeviceSafeInsets
local GetImmersiveChromeStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetImmersiveChromeStore")
local MomentsLocalStorage = require("@game/CorePackages/Workspace/Packages/_Index/Moments/MomentsCommon/MomentsLocalStorage")
local MomentsLocalStorageKeys = require("@game/CorePackages/Workspace/Packages/_Index/Moments/MomentsCommon/MomentsLocalStorageKeys")
local useMomentsSession = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetMomentsStore/MomentsSessionContext").useMomentsSession
local createMomentsFeedSource = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetMomentsStore/createMomentsFeedSource")
local MomentsFeedType = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Enums/MomentsFeedType")
local FFlagMomentsFollowingFeed = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsFollowingFeed")
local FFlagMomentsRecommendationFeedType = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsRecommendationFeedType")
local v6 = if FFlagMomentsFollowingFeed then require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Hooks/useFeedSelection") else nil
local v7 = if FFlagMomentsFollowingFeed then require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/FeedSwitchFade") else nil

local createSignalTracker = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/SignalTracker").createSignalTracker

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SharedFlags")
local fFlagMomentsCreateAvatarPosts = SharedFlags.FFlagMomentsCreateAvatarPosts
local fFlagEnableArgus = SharedFlags.FFlagEnableArgus
local fFlagMomentsCreationFeatureGate = SharedFlags.FFlagMomentsCreationFeatureGate
local fFlagMomentsRenderAvatarPostsInFeed = SharedFlags.FFlagMomentsRenderAvatarPostsInFeed
local fFlagMomentsPostFeedback = SharedFlags.FFlagMomentsPostFeedback
local FFlagMomentsPostFeedbackIxpEnabled = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsPostFeedbackIxpEnabled")
local isStudio = require("@game/CorePackages/Workspace/Packages/_Index/Moments/MomentsCommon/isStudio")
local reportModalCovering = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/MomentsCommon").Media.reportModalCovering
local accountSettingsCovering = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/accountSettingsCovering")
local GetFFlagArgusStudioMockFeed = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/GetFFlagArgusStudioMockFeed")
local createMockFeedSource = module7.createMockFeedSource

local v8 = if fFlagEnableArgus then createSignalTracker() else nil
local module39 = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/MomentUnavailableDialog")

local createRecommendationTelemetry = module7.createRecommendationTelemetry

local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/MomentsCommon")
local analytics = MomentsCommon.Analytics
local eventNames = analytics.EventNames
local sessionManager = analytics.SessionManager
local funnelEventNames = analytics.FunnelEventNames
local fireAnalyticsEvent = analytics.fireAnalyticsEvent
local fireFunnelAnalyticsEvent = analytics.fireFunnelAnalyticsEvent
local useMomentsGating = MomentsCommon.Hooks.useMomentsGating

local uploadLogger = nil
local function getUploadLogger()
	if uploadLogger == nil then
		uploadLogger = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Loggers").Logger:new("Moments.Upload")
	end

	return uploadLogger
end

local function TrendingScreen(p2)
	local state, setState = React.useState(function(): boolean
		return not MomentsLocalStorage.getField(MomentsLocalStorageKeys.CreateTooltipSeen)
	end)

	local state2, setState2 = React.useState(false)
	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)
	local v9 = useScreenBottomInset()

	local v10 = useFeedPlaybackActive()
	local v11, v12

	if FFlagMomentsNavigationEvent then
		v11 = useMomentsTabIsVisible()

		v12 = SignalsReact.useSignalState(GetMomentsPreferencesStore(false).getIsTeleporting)
	else
		v12 = false
		v11 = true
	end

	local v13 = useMomentsSession()

	local v14 = useMomentsHost()
	local openOwnMoments = v14.openOwnMoments

	local openAvatarMomentsCreation = if fFlagMomentsCreateAvatarPosts then v14.openAvatarMomentsCreation else nil

	local v15 = useMomentsGating()
	local platformIntegrationEnabled = v15.isFlyoutEntryEnabled and v15.platformIntegrationEnabled
	local v16

	if fFlagMomentsCreationFeatureGate then
		v16 = not (v15 == nil) and v15.isCreationEnabled
	else
		v16 = nil
	end

	local v17 = useCreationEntry()

	local v18 = useUploadHost({
		onExit = v17.onExitCreation,
		captureSource = v17.captureSource,
		postFeedback = fFlagMomentsPostFeedback and true or nil,
		logsPostFeedbackExposure = FFlagMomentsPostFeedbackIxpEnabled and true or nil
	})

	React.useEffect(function()
		local v19 = sessionManager.getSessionId(funnelEventNames.FunnelTypes.AppNavigation)
			or sessionManager.startSession(funnelEventNames.FunnelTypes.AppNavigation)
		fireFunnelAnalyticsEvent(
			funnelEventNames.FunnelTypes.AppNavigation,
			funnelEventNames.AppNavigationSteps.TrendingScreenView,
			v19
		)
	end, {})

	local v19 = React.useCallback(function()
		setState2(true)
	end, {})

	local v20 = React.useMemo(function()
		if isStudio() and GetFFlagArgusStudioMockFeed() then
			return createMockFeedSource()
		end

		return createMomentsFeedSource(v13.getMomentsSessionId, {
			signalTracker = v8,
			onDeepLinkedMomentUnavailable = v19
		})
	end, { v13, v19 })

	local v21 = React.useMemo(function()
		if not fFlagEnableArgus then
			return nil
		end

		local v23 = {
			getMomentsSessionId = v13.getMomentsSessionId,
			signalTracker = v8,
			feedType = 0
		}

		local v24 = if FFlagMomentsRecommendationFeedType then MomentsFeedType.Trending else nil
		v23.feedType = v24
		return createRecommendationTelemetry(v23)
	end, { v13 })
	local v22

	if FFlagMomentsRecommendationFeedType and FFlagMomentsFollowingFeed then
		v22 = React.useMemo(function()
			if fFlagEnableArgus then
				return createRecommendationTelemetry({
					getMomentsSessionId = v13.getMomentsSessionId,
					signalTracker = v8,
					feedType = MomentsFeedType.Following
				})
			end

			return nil
		end, { v13 })
	end

	local v23 = SignalsReact.useSignalState(GetImmersiveChromeStore(false).getOverlayCovering)

	local v24 = SignalsReact.useSignalState(reportModalCovering.getCovering)

	local v25 = if FFlagMomentsPersonalizedRecommendationsEntryPoint then SignalsReact.useSignalState(accountSettingsCovering.getCovering) else false

	local v26 = not (v17.isCreating or v23 or state2 or v24 or v25)

	if FFlagMomentsFixRecommendationImpressionLifecycle then
		v26 = v26 and v10
	end

	local v27 = v10 and not (v17.isCreating or state2) and not (v24 or v25)
	local v28

	if FFlagMomentsNavigationEvent then
		if v12 then
			v28 = NavigationDestinationType.ExperienceJoin
		elseif v17.isCreating then
			v28 = NavigationDestinationType.Create
		elseif v24 then
			v28 = NavigationDestinationType.Report
		elseif not v11 then
			v28 = NavigationDestinationType.Exit
		end
	end

	local v29 = React.useCallback(function(p3)
		local current = ref.current

		if current ~= nil then
			current.refresh(p3)
		end
	end, {})

	local v30 = React.useCallback(function(p3)
		local current = ref.current

		if current ~= nil then
			current.flushView(p3)
		end
	end, {})
	local v31

	if fFlagMomentsCreateAvatarPosts then
		v31 = React.useCallback(function()
			logCreateIntent(funnelEventNames.CreationIntentSource.TopBar)

			if FFlagMomentsNavigationEvent then
				v30(NavigationDestinationType.Create)
			end

			if openAvatarMomentsCreation ~= nil then
				openAvatarMomentsCreation()
			end
		end, { v30, openAvatarMomentsCreation })
	else
		v31 = nil
	end

	if not fFlagMomentsCreateAvatarPosts or openAvatarMomentsCreation == nil then
		v31 = nil
	end

	local v32

	if v6 == nil then
		v32 = nil
	else
		if not FFlagMomentsRecommendationFeedType then
			v22 = nil
		end

		v32 = v6({
			trendingSource = v20,
			trendingTelemetry = v21,
			followingTelemetry = v22,
			refreshFeed = v29,
			flushView = v30
		})
	end

	if v32 ~= nil then
		v20 = v32.source
	end

	if v32 ~= nil then
		v21 = v32.telemetry
	end

	React.useEffect(function()
		if not FFlagMomentsFlushDwellBeforeNavigation or p2.navigation.addListener == nil then
			return nil
		end

		local v33 = p2.navigation.addListener(RoactNavigation.Events.WillBlur, function()
			v30()
		end)
		return function()
			v33.remove()
		end
	end, { p2.navigation, v30 })

	React.useEffect(function()
		local reloadPageConnection = RobloxAppEvents.ReloadPage:connect(function(p3)
			if p3 == appPage.Moments then
				if v32 == nil or v32.getSelected() ~= MomentsFeedType.Following then
					v29()
				else
					v32.select(MomentsFeedType.Trending)
				end
			end
		end)

		return function()
			reloadPageConnection:disconnect()
		end
	end, { v29, v32 })

	local v33 = GetUploadStore(false)
	local v34 = SignalsReact.useSignalState(v33.getState)
	local v35 = SignalsReact.useSignalState(v33.getUploadedMoment)
	React.useEffect(function()
		if v34 ~= "Success" then
			ref2.current = v34
		elseif ref2.current ~= "Success" then
			ref2.current = v34

			if v32 == nil or v32.getSelected() ~= MomentsFeedType.Following then
				local current = ref.current

				if type(v35) == "table" and v35.momentId ~= nil and current ~= nil then
					if uploadLogger == nil then
						uploadLogger = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Loggers").Logger:new("Moments.Upload")
					end

					uploadLogger:debug(
						"event=feed_prepend_uploaded momentId={} assetId={}",
						v35.momentId,
						(tostring(v35.assetId))
					)

					current.prependMoment(v35)
				else
					if uploadLogger == nil then
						uploadLogger = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Loggers").Logger:new("Moments.Upload")
					end

					uploadLogger:debug(
						"event=feed_refresh_after_upload uploadedMoment={} hasController={}",
						tostring(v35),
						(tostring(current ~= nil))
					)

					v29()
				end
			else
				if uploadLogger == nil then
					uploadLogger = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Loggers").Logger:new("Moments.Upload")
				end

				uploadLogger:debug("event=feed_upload_skipped_on_following")
			end
		end
	end, { v34, v35, v29, v32 })

	local v36 = React.useCallback(function()
		setState(false)
		MomentsLocalStorage.setField(MomentsLocalStorageKeys.CreateTooltipSeen, true)
	end, {})

	local v37 = React.useCallback(function()
		logCreateIntent(funnelEventNames.CreationIntentSource.TopBar)
		v17.onCreatePressed()
	end, { v17.onCreatePressed })

	local v38 = React.useCallback(function()
		fireAnalyticsEvent(eventNames.FeedHomeButtonPressed)

		if v32 ~= nil then
			v32.select(MomentsFeedType.Trending)
			return
		end

		local v40 = if FFlagMomentsNavigationEvent then NavigationDestinationType.Trending else nil
		v29(v40)
	end, { v29, v32 })

	local v39 = React.useCallback(function()
		fireAnalyticsEvent(eventNames.MyCreationButtonPressed)

		if openOwnMoments ~= nil then
			if FFlagMomentsFlushDwellBeforeNavigation then
				local v41 = if FFlagMomentsNavigationEvent then NavigationDestinationType.MyMoments else nil
				v30(v41)
			end

			openOwnMoments()
		end
	end, { openOwnMoments, v30 })

	local v40 = React.useCallback(function(p3)
		if p3 == MomentsFeedType.Trending then
			v38()
		elseif v32 ~= nil then
			v32.select(p3)
		end
	end, { v38, v32 })

	local useMemo = React.useMemo
	local function fn()
		local createElement = React.createElement
		local v42 = {
			isBaseScreen = true,
			showTopScrim = true,
			showFtuxTooltip = state and v10 and (not fFlagMomentsCreationFeatureGate or v16),
			showHamburger = platformIntegrationEnabled,
			onFtuxTooltipDismissed = v36,
			onCreatePressed = nil,
			onCreateAvatarMomentPressed = nil,
			onNavigateToTrending = nil,
			onNavigateToMyMoments = nil,
			selectedFeedType = 0,
			onFeedTypeSelected = 0
		}
		local v43 = if not (fFlagMomentsCreationFeatureGate and not v16) then v37 else nil
		v42.onCreatePressed = v43

		v42.onCreateAvatarMomentPressed = if fFlagMomentsCreateAvatarPosts then v31 else nil

		v42.onNavigateToTrending = v38
		v42.onNavigateToMyMoments = v39
		local v45 = if v32 ~= nil then v32.selected else nil
		v42.selectedFeedType = v45
		local v46 = if v32 ~= nil then v40 else nil
		v42.onFeedTypeSelected = v46
		return createElement(TopBar, v42)
	end

	local v42 = if fFlagMomentsCreationFeatureGate then v16 else false
	local v44 = useMemo(fn, {
		state,
		v10,
		v42,
		platformIntegrationEnabled,
		v36,
		v37,
		if fFlagMomentsCreateAvatarPosts then v31 else nil,
		v38,
		v39,
		v40,
		v32
	})
	local v45

	if FFlagMomentsFixFeedForDeviceSafeInsets then
		local v46 = MomentsCommon.Hooks.useDeviceInsets()
		v45 = not shouldUseDeviceSafeInsets and 0 or v46.top
	else
		v45 = 0
	end

	local v46 = React.useCallback(function(p3)
		local element = React.createElement(MomentOverlayInsetContext.Context.Provider, { value = v9 }, {
			Feed = p3
		})

		local v47 = FFlagMomentsFeedAboveNavBar and { bottom = UDim.new(0, v9) } or nil

		local createElement = React.createElement
		local v49 = {
			backgroundStyle = fFlagMomentsRenderAvatarPostsInFeed and {
				Transparency = 1
			} or nil,
			tag = {
				["size-full"] = not v5
			},
			Position = 0,
			Size = 0,
			testId = "--moments-feed-container-full-bleed",
			padding = 0,
			ZIndex = 0
		}
		local v50 = if v5 then UDim2.fromOffset(0, -v45) else nil
		v49.Position = v50
		local v51 = if v5 then UDim2.new(1, 0, 1, v45) else nil
		v49.Size = v51

		v49.padding = v47
		v49.ZIndex = Constants.DisplayOrder.Feed

		local v53 = if v7 ~= nil and v32 ~= nil then React.createElement(v7, {
			feedKey = v32.selected,
			ZIndex = 2
		}) else nil
		return createElement(view, v49, { Feed = element, SwitchFade = v53 })
	end, { v9, v45, v32 })

	local createElement = React.createElement

	local createElement2 = React.createElement
	local v51 = {
		source = v20,
		active = v26,
		playbackActive = v27,
		telemetry = v21,
		inactiveDestination = v28,
		controllerRef = ref,
		trackSurfaceLoad = true,
		header = v44,
		renderFeedContainer = v46,
		emptyState = 0,
		caughtUpState = 0
	}

	local v52 = if v32 ~= nil then v32.emptyState else nil
	v51.emptyState = v52
	local v53 = if v32 ~= nil then v32.caughtUpState else nil
	v51.caughtUpState = v53
	local v49 = {
		Surface = createElement2(MomentsFeedSurface, v51),
		MomentUnavailableDialog = 0,
		CreationFlowOverlay = 0,
		FtuxOverlay = 0
	}
	local v54

	if v10 and state2 then
		v54 = React.createElement(module39, {
			onDismiss = function()
				setState2(false)
			end
		})
	end

	v49.MomentUnavailableDialog = v54

	local v55 = if v17.isCreating then React.createElement(
		view,
		{ tag = "size-full", ZIndex = Constants.DisplayOrder.Modals },
		{
			Screen = React.createElement(creationFlowScreen, { host = v18 })
		}
	) else nil
	v49.CreationFlowOverlay = v55

	local v56 = if v17.showFtux then React.createElement(
		view,
		{ tag = "size-full", ZIndex = Constants.DisplayOrder.Modals },
		{
			Screen = React.createElement(FTUXEducationScreen, { onClose = v17.onExitFtux })
		}
	) else nil
	v49.FtuxOverlay = v56
	return createElement(view, {
		backgroundStyle = fFlagMomentsRenderAvatarPostsInFeed and { Transparency = 1 } or nil,
		tag = {
			["size-full"] = fFlagMomentsRenderAvatarPostsInFeed,
			["size-full bg-surface-0"] = not fFlagMomentsRenderAvatarPostsInFeed
		}
	}, v49)
end

return TrendingScreen
