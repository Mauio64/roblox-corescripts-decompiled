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
local v6 = if FFlagMomentsFollowingFeed then require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Hooks/useFeedSelection") else nil
local v7 = if FFlagMomentsFollowingFeed then require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/FeedSwitchFade") else nil

local createSignalTracker = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/SignalTracker").createSignalTracker

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SharedFlags")
local fFlagEnableArgus = SharedFlags.FFlagEnableArgus
local fFlagMomentsCreationFeatureGate = SharedFlags.FFlagMomentsCreationFeatureGate
local fFlagMomentsRenderAvatarPostsInFeed = SharedFlags.FFlagMomentsRenderAvatarPostsInFeed
local isStudio = require("@game/CorePackages/Workspace/Packages/_Index/Moments/MomentsCommon/isStudio")
local reportModalCovering = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/MomentsCommon").Media.reportModalCovering
local GetFFlagArgusStudioMockFeed = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/GetFFlagArgusStudioMockFeed")
local createMockFeedSource = module7.createMockFeedSource

local v8 = if fFlagEnableArgus then createSignalTracker() else nil
local module35 = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/MomentUnavailableDialog")

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

	local openOwnMoments = useMomentsHost().openOwnMoments
	local v14 = useMomentsGating()
	local platformIntegrationEnabled = v14.isFlyoutEntryEnabled and v14.platformIntegrationEnabled
	local v15

	if fFlagMomentsCreationFeatureGate then
		v15 = not (v14 == nil) and v14.isCreationEnabled
	else
		v15 = nil
	end

	local v16 = useCreationEntry()

	local v17 = useUploadHost({
		onExit = v16.onExitCreation,
		captureSource = v16.captureSource
	})

	React.useEffect(function()
		local v18 = sessionManager.getSessionId(funnelEventNames.FunnelTypes.AppNavigation)
			or sessionManager.startSession(funnelEventNames.FunnelTypes.AppNavigation)
		fireFunnelAnalyticsEvent(
			funnelEventNames.FunnelTypes.AppNavigation,
			funnelEventNames.AppNavigationSteps.TrendingScreenView,
			v18
		)
	end, {})

	local v18 = React.useCallback(function()
		setState2(true)
	end, {})

	local v19 = React.useMemo(function()
		if isStudio() and GetFFlagArgusStudioMockFeed() then
			return createMockFeedSource()
		end

		return createMomentsFeedSource(v13.getMomentsSessionId, {
			signalTracker = v8,
			onDeepLinkedMomentUnavailable = v18
		})
	end, { v13, v18 })

	local v20 = React.useMemo(function()
		if fFlagEnableArgus then
			return createRecommendationTelemetry({
				getMomentsSessionId = v13.getMomentsSessionId,
				signalTracker = v8
			})
		end

		return nil
	end, { v13 })

	local v21 = SignalsReact.useSignalState(GetImmersiveChromeStore(false).getOverlayCovering)

	local v22 = SignalsReact.useSignalState(reportModalCovering.getCovering)
	local v23 = not (v16.isCreating or v21 or state2 or v22)

	if FFlagMomentsFixRecommendationImpressionLifecycle then
		v23 = v23 and v10
	end

	local v24 = v10 and not v16.isCreating and not (state2 or v22)
	local v25

	if FFlagMomentsNavigationEvent then
		if v12 then
			v25 = NavigationDestinationType.ExperienceJoin
		elseif v16.isCreating then
			v25 = NavigationDestinationType.Create
		elseif v22 then
			v25 = NavigationDestinationType.Report
		elseif not v11 then
			v25 = NavigationDestinationType.Exit
		end
	end

	local v26 = React.useCallback(function(p3)
		local current = ref.current

		if current ~= nil then
			current.refresh(p3)
		end
	end, {})

	local v27 = React.useCallback(function(p3)
		local current = ref.current

		if current ~= nil then
			current.flushView(p3)
		end
	end, {})
	local v28

	if v6 == nil then
		v28 = nil
	else
		v28 = v6({
			trendingSource = v19,
			trendingTelemetry = v20,
			refreshFeed = v26,
			flushView = v27
		})
	end

	if v28 ~= nil then
		v19 = v28.source
	end

	if v28 ~= nil then
		v20 = v28.telemetry
	end

	React.useEffect(function()
		if not FFlagMomentsFlushDwellBeforeNavigation or p2.navigation.addListener == nil then
			return nil
		end

		local v29 = p2.navigation.addListener(RoactNavigation.Events.WillBlur, function()
			v27()
		end)
		return function()
			v29.remove()
		end
	end, { p2.navigation, v27 })

	React.useEffect(function()
		local reloadPageConnection = RobloxAppEvents.ReloadPage:connect(function(p3)
			if p3 == appPage.Moments then
				if v28 == nil or v28.getSelected() ~= MomentsFeedType.Following then
					v26()
				else
					v28.select(MomentsFeedType.Trending)
				end
			end
		end)

		return function()
			reloadPageConnection:disconnect()
		end
	end, { v26, v28 })

	local v29 = GetUploadStore(false)
	local v30 = SignalsReact.useSignalState(v29.getState)
	local v31 = SignalsReact.useSignalState(v29.getUploadedMoment)
	React.useEffect(function()
		if v30 ~= "Success" then
			ref2.current = v30
		elseif ref2.current ~= "Success" then
			ref2.current = v30

			if v28 == nil or v28.getSelected() ~= MomentsFeedType.Following then
				local current = ref.current

				if type(v31) == "table" and v31.momentId ~= nil and current ~= nil then
					if uploadLogger == nil then
						uploadLogger = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Loggers").Logger:new("Moments.Upload")
					end

					uploadLogger:debug(
						"event=feed_prepend_uploaded momentId={} assetId={}",
						v31.momentId,
						(tostring(v31.assetId))
					)

					current.prependMoment(v31)
				else
					if uploadLogger == nil then
						uploadLogger = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Loggers").Logger:new("Moments.Upload")
					end

					uploadLogger:debug(
						"event=feed_refresh_after_upload uploadedMoment={} hasController={}",
						tostring(v31),
						(tostring(current ~= nil))
					)

					v26()
				end
			else
				if uploadLogger == nil then
					uploadLogger = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Loggers").Logger:new("Moments.Upload")
				end

				uploadLogger:debug("event=feed_upload_skipped_on_following")
			end
		end
	end, { v30, v31, v26, v28 })

	local v32 = React.useCallback(function()
		setState(false)
		MomentsLocalStorage.setField(MomentsLocalStorageKeys.CreateTooltipSeen, true)
	end, {})

	local v33 = React.useCallback(function()
		logCreateIntent(funnelEventNames.CreationIntentSource.TopBar)
		v16.onCreatePressed()
	end, { v16.onCreatePressed })

	local v34 = React.useCallback(function()
		fireAnalyticsEvent(eventNames.FeedHomeButtonPressed)

		if v28 ~= nil then
			v28.select(MomentsFeedType.Trending)
			return
		end

		local v36 = if FFlagMomentsNavigationEvent then NavigationDestinationType.Trending else nil
		v26(v36)
	end, { v26, v28 })

	local v35 = React.useCallback(function()
		fireAnalyticsEvent(eventNames.MyCreationButtonPressed)

		if openOwnMoments ~= nil then
			if FFlagMomentsFlushDwellBeforeNavigation then
				local v37 = if FFlagMomentsNavigationEvent then NavigationDestinationType.MyMoments else nil
				v27(v37)
			end

			openOwnMoments()
		end
	end, { openOwnMoments, v27 })

	local function fn()
		local createElement = React.createElement
		local v37 = {
			isBaseScreen = true,
			showTopScrim = true,
			showFtuxTooltip = state and v10 and (not fFlagMomentsCreationFeatureGate or v15),
			showHamburger = platformIntegrationEnabled,
			onFtuxTooltipDismissed = v32,
			onCreatePressed = nil,
			onNavigateToTrending = nil,
			onNavigateToMyMoments = nil,
			selectedFeedType = 0,
			onFeedTypeSelected = 0
		}
		local v38 = if not (fFlagMomentsCreationFeatureGate and not v15) then v33 else nil
		v37.onCreatePressed = v38

		v37.onNavigateToTrending = v34
		v37.onNavigateToMyMoments = v35
		local v39 = if v28 ~= nil then v28.selected else nil
		v37.selectedFeedType = v39
		local v40 = if v28 ~= nil then v28.select else nil
		v37.onFeedTypeSelected = v40
		return createElement(TopBar, v37)
	end

	local v38 = React.useMemo(fn, {
		state,
		v10,
		if fFlagMomentsCreationFeatureGate then v15 else false,
		platformIntegrationEnabled,
		v32,
		v33,
		v34,
		v35,
		v28
	})
	local v39

	if FFlagMomentsFixFeedForDeviceSafeInsets then
		local v40 = MomentsCommon.Hooks.useDeviceInsets()
		v39 = not shouldUseDeviceSafeInsets and 0 or v40.top
	else
		v39 = 0
	end

	local v40 = React.useCallback(function(p3)
		local element = React.createElement(MomentOverlayInsetContext.Context.Provider, { value = v9 }, {
			Feed = p3
		})

		local v41 = FFlagMomentsFeedAboveNavBar and { bottom = UDim.new(0, v9) } or nil

		local createElement = React.createElement
		local v43 = {
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
		local v44 = if v5 then UDim2.fromOffset(0, -v39) else nil
		v43.Position = v44
		local v45 = if v5 then UDim2.new(1, 0, 1, v39) else nil
		v43.Size = v45

		v43.padding = v41
		v43.ZIndex = Constants.DisplayOrder.Feed

		local v47 = if v7 ~= nil and v28 ~= nil then React.createElement(v7, {
			feedKey = v28.selected,
			ZIndex = 2
		}) else nil
		return createElement(view, v43, { Feed = element, SwitchFade = v47 })
	end, { v9, v39, v28 })

	local createElement = React.createElement

	local createElement2 = React.createElement
	local v45 = {
		source = v19,
		active = v23,
		playbackActive = v24,
		telemetry = v20,
		inactiveDestination = v25,
		controllerRef = ref,
		trackSurfaceLoad = true,
		header = v38,
		renderFeedContainer = v40,
		emptyState = 0,
		caughtUpState = 0
	}

	local v46 = if v28 ~= nil then v28.emptyState else nil
	v45.emptyState = v46
	local v47 = if v28 ~= nil then v28.caughtUpState else nil
	v45.caughtUpState = v47
	local v43 = {
		Surface = createElement2(MomentsFeedSurface, v45),
		MomentUnavailableDialog = 0,
		CreationFlowOverlay = 0,
		FtuxOverlay = 0
	}
	local v48

	if v10 and state2 then
		v48 = React.createElement(module35, {
			onDismiss = function()
				setState2(false)
			end
		})
	end

	v43.MomentUnavailableDialog = v48

	local v49 = if v16.isCreating then React.createElement(
		view,
		{ tag = "size-full", ZIndex = Constants.DisplayOrder.Modals },
		{
			Screen = React.createElement(creationFlowScreen, { host = v17 })
		}
	) else nil
	v43.CreationFlowOverlay = v49

	local v50 = if v16.showFtux then React.createElement(
		view,
		{ tag = "size-full", ZIndex = Constants.DisplayOrder.Modals },
		{
			Screen = React.createElement(FTUXEducationScreen, { onClose = v16.onExitFtux })
		}
	) else nil
	v43.FtuxOverlay = v50
	return createElement(view, {
		backgroundStyle = fFlagMomentsRenderAvatarPostsInFeed and { Transparency = 1 } or nil,
		tag = {
			["size-full"] = fFlagMomentsRenderAvatarPostsInFeed,
			["size-full bg-surface-0"] = not fFlagMomentsRenderAvatarPostsInFeed
		}
	}, v43)
end

return TrendingScreen
