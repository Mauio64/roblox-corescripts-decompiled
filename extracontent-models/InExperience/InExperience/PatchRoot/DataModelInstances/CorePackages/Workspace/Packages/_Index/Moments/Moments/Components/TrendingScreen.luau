local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local RobloxAppEvents = require(parent.RobloxAppEvents)
local RoactNavigation = require(parent.RoactNavigation)

local View = Foundation.View

local TopBar = require(Moments.Components.TopBar)
local MomentsFeedSurface = require(Moments.Components.MomentsFeedSurface)
local Feed = require(Moments.Components.Feed)

local MomentsCreation = require(parent.MomentsCreation)
local CreationFlowScreen = MomentsCreation.CreationFlowScreen
local FTUXEducationScreen = require(Moments.Components.FTUXEducationScreen)
local MomentsHostContext = require(Moments.MomentsHostContext)
local useMomentsHost = MomentsHostContext.useMomentsHost
local Constants = require(Moments.Constants)
local useScreenBottomInset = require(Moments.Hooks.useScreenBottomInset)
local useFeedPlaybackActive = require(Moments.Hooks.useFeedPlaybackActive)
local useMomentsTabIsVisible = require(Moments.Hooks.useMomentsTabIsVisible)
local GetMomentsPreferencesStore = require(Moments.Stores.GetMomentsPreferencesStore)
local NavigationDestinationType = require(Moments.Enums.NavigationDestinationType)
local FFlagMomentsNavigationEvent = require(Moments.Flags.FFlagMomentsNavigationEvent)

local FFlagMomentsFixRecommendationImpressionLifecycle = require(Moments.Flags.FFlagMomentsFixRecommendationImpressionLifecycle)
local FFlagMomentsFlushDwellBeforeNavigation = require(Moments.Flags.FFlagMomentsFlushDwellBeforeNavigation)
local useCreationEntry = require(Moments.Hooks.useCreationEntry)
local useUploadHost = require(Moments.Hooks.useUploadHost)
local logCreateIntent = require(Moments.Analytics.logCreateIntent)
local GetUploadStore = require(Moments.Stores.GetUploadStore)
local SignalsReact = require(parent.SignalsReact)
local MomentOverlayInsetContext = require(Moments.Components.Feed.Items.Moment.MomentOverlayInsetContext)
local FFlagMomentsFeedAboveNavBar = require(Moments.Flags.FFlagMomentsFeedAboveNavBar)
local FFlagMomentsFixFeedForDeviceSafeInsets = require(Moments.Flags.FFlagMomentsFixFeedForDeviceSafeInsets)
local Display = require(parent.Display)
local shouldUseDeviceSafeInsets = Display.shouldUseDeviceSafeInsets
local v = FFlagMomentsFixFeedForDeviceSafeInsets and shouldUseDeviceSafeInsets
local GetImmersiveChromeStore = require(Moments.Stores.GetImmersiveChromeStore)
local MomentsLocalStorage = require(parent.MomentsCommon.MomentsLocalStorage)
local MomentsLocalStorageKeys = require(parent.MomentsCommon.MomentsLocalStorageKeys)
local MomentsSessionContext = require(Moments.Stores.GetMomentsStore.MomentsSessionContext)
local useMomentsSession = MomentsSessionContext.useMomentsSession
local createMomentsFeedSource = require(Moments.Stores.GetMomentsStore.createMomentsFeedSource)
local MomentsFeedType = require(Moments.Enums.MomentsFeedType)
local FFlagMomentsFollowingFeed = require(Moments.Flags.FFlagMomentsFollowingFeed)
local useFeedSelection

if FFlagMomentsFollowingFeed then
	useFeedSelection = require(Moments.Hooks.useFeedSelection)
else
	useFeedSelection = nil
end

local FeedSwitchFade

if FFlagMomentsFollowingFeed then
	FeedSwitchFade = require(Moments.Components.FeedSwitchFade)
else
	FeedSwitchFade = nil
end

local SignalTracker = require(Moments.SignalTracker)
local createSignalTracker = SignalTracker.createSignalTracker

local SharedFlags = require(parent.SharedFlags)
local FFlagEnableArgus = SharedFlags.FFlagEnableArgus
local FFlagMomentsCreationFeatureGate = SharedFlags.FFlagMomentsCreationFeatureGate
local FFlagMomentsRenderAvatarPostsInFeed = SharedFlags.FFlagMomentsRenderAvatarPostsInFeed
local isStudio = require(parent.MomentsCommon.isStudio)
local MomentsCommon = require(parent.MomentsCommon)
local reportModalCovering = MomentsCommon.Media.reportModalCovering
local GetFFlagArgusStudioMockFeed = require(Moments.Flags.GetFFlagArgusStudioMockFeed)
local createMockFeedSource = Feed.createMockFeedSource
local signalTracker

if FFlagEnableArgus then
	signalTracker = createSignalTracker()
else
	signalTracker = nil
end

local MomentUnavailableDialog = require(Moments.Components.MomentUnavailableDialog)

local createRecommendationTelemetry = Feed.createRecommendationTelemetry

local MomentsCommon2 = require(parent.MomentsCommon)
local Analytics = MomentsCommon2.Analytics
local EventNames = Analytics.EventNames
local SessionManager = Analytics.SessionManager
local FunnelEventNames = Analytics.FunnelEventNames
local fireAnalyticsEvent = Analytics.fireAnalyticsEvent
local fireFunnelAnalyticsEvent = Analytics.fireFunnelAnalyticsEvent
local useMomentsGating = MomentsCommon2.Hooks.useMomentsGating

local uploadLogger = nil
local function getUploadLogger() -- 3 equivalent calls inferred from this helper
	if uploadLogger == nil then
		local Loggers = require(parent.Loggers)
		uploadLogger = Loggers.Logger:new("Moments.Upload")
	end

	return uploadLogger
end

local function TrendingScreen(p)
	local state, setState = React.useState(function(): boolean
		return not MomentsLocalStorage.getField(MomentsLocalStorageKeys.CreateTooltipSeen)
	end)

	local state2, setState2 = React.useState(false)
	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)
	local v2 = useScreenBottomInset()

	local v3 = useFeedPlaybackActive()
	local v4, v5

	if FFlagMomentsNavigationEvent then
		v4 = useMomentsTabIsVisible()

		v5 = SignalsReact.useSignalState(GetMomentsPreferencesStore(false).getIsTeleporting)
	else
		v5 = false
		v4 = true
	end

	local v6 = useMomentsSession()

	local openOwnMoments = useMomentsHost().openOwnMoments
	local v7 = useMomentsGating()
	local platformIntegrationEnabled = v7.isFlyoutEntryEnabled and v7.platformIntegrationEnabled
	local v8

	if FFlagMomentsCreationFeatureGate then
		v8 = not (v7 == nil) and v7.isCreationEnabled
	else
		v8 = nil
	end

	local v9 = useCreationEntry()

	local host = useUploadHost({ onExit = v9.onExitCreation, captureSource = v9.captureSource })

	React.useEffect(function()
		local v10 = SessionManager.getSessionId(FunnelEventNames.FunnelTypes.AppNavigation)
			or SessionManager.startSession(FunnelEventNames.FunnelTypes.AppNavigation)
		fireFunnelAnalyticsEvent(
			FunnelEventNames.FunnelTypes.AppNavigation,
			FunnelEventNames.AppNavigationSteps.TrendingScreenView,
			v10
		)
	end, {})

	local onDeepLinkedMomentUnavailable = React.useCallback(function()
		setState2(true)
	end, {})

	local v10 = React.useMemo(function()
		if isStudio() and GetFFlagArgusStudioMockFeed() then
			return createMockFeedSource()
		end

		return createMomentsFeedSource(v6.getMomentsSessionId, {
			signalTracker = signalTracker,
			onDeepLinkedMomentUnavailable = onDeepLinkedMomentUnavailable
		})
	end, { v6, onDeepLinkedMomentUnavailable })

	local v11 = React.useMemo(function()
		if FFlagEnableArgus then
			return createRecommendationTelemetry({
				getMomentsSessionId = v6.getMomentsSessionId,
				signalTracker = signalTracker
			})
		end

		return nil
	end, { v6 })

	local v12 = SignalsReact.useSignalState(GetImmersiveChromeStore(false).getOverlayCovering)

	local v13 = SignalsReact.useSignalState(reportModalCovering.getCovering)
	local active = not (v9.isCreating or v12 or state2 or v13)

	if FFlagMomentsFixRecommendationImpressionLifecycle then
		active = active and v3
	end

	local playbackActive = v3 and not v9.isCreating and not (state2 or v13)
	local inactiveDestination

	if FFlagMomentsNavigationEvent then
		if v5 then
			inactiveDestination = NavigationDestinationType.ExperienceJoin
		elseif v9.isCreating then
			inactiveDestination = NavigationDestinationType.Create
		elseif v13 then
			inactiveDestination = NavigationDestinationType.Report
		elseif not v4 then
			inactiveDestination = NavigationDestinationType.Exit
		end
	end

	local refreshFeed = React.useCallback(function(p2)
		local current = ref.current

		if current ~= nil then
			current.refresh(p2)
		end
	end, {})

	local flushView = React.useCallback(function(p2)
		local current = ref.current

		if current ~= nil then
			current.flushView(p2)
		end
	end, {})
	local v14

	if useFeedSelection == nil then
		v14 = nil
	else
		v14 = useFeedSelection({
			trendingSource = v10,
			trendingTelemetry = v11,
			refreshFeed = refreshFeed,
			flushView = flushView
		})
	end

	if v14 ~= nil then
		v10 = v14.source
	end

	if v14 ~= nil then
		v11 = v14.telemetry
	end

	React.useEffect(function()
		if not FFlagMomentsFlushDwellBeforeNavigation or p.navigation.addListener == nil then
			return nil
		end

		local v15 = p.navigation.addListener(RoactNavigation.Events.WillBlur, function()
			flushView()
		end)
		return function()
			v15.remove()
		end
	end, { p.navigation, flushView })

	React.useEffect(function()
		local reloadPageConnection = RobloxAppEvents.ReloadPage:connect(function(p2)
			if p2 == AppPage.Moments then
				if v14 == nil or v14.getSelected() ~= MomentsFeedType.Following then
					refreshFeed()
				else
					v14.select(MomentsFeedType.Trending)
				end
			end
		end)

		return function()
			reloadPageConnection:disconnect()
		end
	end, { refreshFeed, v14 })

	local uploadStore = GetUploadStore(false)
	local current2 = SignalsReact.useSignalState(uploadStore.getState)
	local v15 = SignalsReact.useSignalState(uploadStore.getUploadedMoment)
	React.useEffect(function()
		if current2 ~= "Success" then
			ref2.current = current2
		elseif ref2.current ~= "Success" then
			ref2.current = current2

			if v14 == nil or v14.getSelected() ~= MomentsFeedType.Following then
				local current = ref.current

				if type(v15) == "table" and v15.momentId ~= nil and current ~= nil then
					getUploadLogger():debug( -- inferred equivalent call
						"event=feed_prepend_uploaded momentId={} assetId={}",
						v15.momentId,
						(tostring(v15.assetId))
					)

					current.prependMoment(v15)
				else
					getUploadLogger():debug( -- inferred equivalent call
						"event=feed_refresh_after_upload uploadedMoment={} hasController={}",
						tostring(v15),
						(tostring(current ~= nil))
					)

					refreshFeed()
				end
			else
				getUploadLogger():debug("event=feed_upload_skipped_on_following") -- inferred equivalent call
			end
		end
	end, { current2, v15, refreshFeed, v14 })

	local onFtuxTooltipDismissed = React.useCallback(function()
		setState(false)
		MomentsLocalStorage.setField(MomentsLocalStorageKeys.CreateTooltipSeen, true)
	end, {})

	local v16 = React.useCallback(function()
		logCreateIntent(FunnelEventNames.CreationIntentSource.TopBar)
		v9.onCreatePressed()
	end, { v9.onCreatePressed })

	local onNavigateToTrending = React.useCallback(function()
		fireAnalyticsEvent(EventNames.FeedHomeButtonPressed)

		if v14 ~= nil then
			v14.select(MomentsFeedType.Trending)
			return
		end

		local v17

		if FFlagMomentsNavigationEvent then
			v17 = NavigationDestinationType.Trending
		end

		refreshFeed(v17)
	end, { refreshFeed, v14 })

	local onNavigateToMyMoments = React.useCallback(function()
		fireAnalyticsEvent(EventNames.MyCreationButtonPressed)

		if openOwnMoments ~= nil then
			if FFlagMomentsFlushDwellBeforeNavigation then
				local v17

				if FFlagMomentsNavigationEvent then
					v17 = NavigationDestinationType.MyMoments
				end

				flushView(v17)
			end

			openOwnMoments()
		end
	end, { openOwnMoments, flushView })

	local useMemo = React.useMemo
	local function fn()
		local createElement = React.createElement
		local v17 = {
			isBaseScreen = true,
			showTopScrim = true,
			showFtuxTooltip = state and v3 and (not FFlagMomentsCreationFeatureGate or v8),
			showHamburger = platformIntegrationEnabled,
			onFtuxTooltipDismissed = onFtuxTooltipDismissed,
			onCreatePressed = nil,
			onNavigateToTrending = nil,
			onNavigateToMyMoments = nil,
			selectedFeedType = 0,
			onFeedTypeSelected = 0
		}
		local onCreatePressed

		if not (FFlagMomentsCreationFeatureGate and not v8) then
			onCreatePressed = v16
		end

		v17.onCreatePressed = onCreatePressed

		v17.onNavigateToTrending = onNavigateToTrending
		v17.onNavigateToMyMoments = onNavigateToMyMoments
		local selectedFeedType

		if v14 ~= nil then
			selectedFeedType = v14.selected
		end

		v17.selectedFeedType = selectedFeedType
		local onFeedTypeSelected

		if v14 ~= nil then
			onFeedTypeSelected = v14.select
		end

		v17.onFeedTypeSelected = onFeedTypeSelected
		return createElement(TopBar, v17)
	end

	local v17 = if FFlagMomentsCreationFeatureGate then v8 else false
	local header = useMemo(fn, {
		state,
		v3,
		v17,
		platformIntegrationEnabled,
		onFtuxTooltipDismissed,
		v16,
		onNavigateToTrending,
		onNavigateToMyMoments,
		v14
	})
	local v18

	if FFlagMomentsFixFeedForDeviceSafeInsets then
		local v19 = MomentsCommon2.Hooks.useDeviceInsets()
		v18 = not shouldUseDeviceSafeInsets and 0 or v19.top
	else
		v18 = 0
	end

	local renderFeedContainer = React.useCallback(function(feed)
		local element = React.createElement(MomentOverlayInsetContext.Context.Provider, {
			value = v2
		}, { Feed = feed })

		local padding = FFlagMomentsFeedAboveNavBar and { bottom = UDim.new(0, v2) } or nil

		local createElement = React.createElement
		local v19 = {
			backgroundStyle = FFlagMomentsRenderAvatarPostsInFeed and { Transparency = 1 } or nil,
			tag = {
				["size-full"] = not v
			},
			Position = 0,
			Size = 0,
			testId = "--moments-feed-container-full-bleed",
			padding = 0,
			ZIndex = 0
		}
		local position

		if v then
			position = UDim2.fromOffset(0, -v18)
		end

		v19.Position = position
		local size

		if v then
			size = UDim2.new(1, 0, 1, v18)
		end

		v19.Size = size

		v19.padding = padding
		v19.ZIndex = Constants.DisplayOrder.Feed
		local switchFade

		if not (FeedSwitchFade == nil or v14 == nil) then
			switchFade = React.createElement(FeedSwitchFade, { feedKey = v14.selected, ZIndex = 2 })
		end

		return createElement(View, v19, { Feed = element, SwitchFade = switchFade })
	end, { v2, v18, v14 })

	local createElement = React.createElement

	local createElement2 = React.createElement
	local v19 = {
		source = v10,
		active = active,
		playbackActive = playbackActive,
		telemetry = v11,
		inactiveDestination = inactiveDestination,
		controllerRef = ref,
		trackSurfaceLoad = true,
		header = header,
		renderFeedContainer = renderFeedContainer,
		emptyState = 0,
		caughtUpState = 0
	}
	local emptyState

	if v14 ~= nil then
		emptyState = v14.emptyState
	end

	v19.emptyState = emptyState
	local caughtUpState

	if v14 ~= nil then
		caughtUpState = v14.caughtUpState
	end

	v19.caughtUpState = caughtUpState
	local v20 = {
		Surface = createElement2(MomentsFeedSurface, v19),
		MomentUnavailableDialog = 0,
		CreationFlowOverlay = 0,
		FtuxOverlay = 0
	}
	local momentUnavailableDialog

	if v3 and state2 then
		momentUnavailableDialog = React.createElement(MomentUnavailableDialog, {
			onDismiss = function()
				setState2(false)
			end
		})
	end

	v20.MomentUnavailableDialog = momentUnavailableDialog
	local creationFlowOverlay

	if v9.isCreating then
		creationFlowOverlay = React.createElement(View, {
			tag = "size-full",
			ZIndex = Constants.DisplayOrder.Modals
		}, {
			Screen = React.createElement(CreationFlowScreen, { host = host })
		})
	end

	v20.CreationFlowOverlay = creationFlowOverlay
	local ftuxOverlay

	if v9.showFtux then
		ftuxOverlay = React.createElement(View, {
			tag = "size-full",
			ZIndex = Constants.DisplayOrder.Modals
		}, {
			Screen = React.createElement(FTUXEducationScreen, { onClose = v9.onExitFtux })
		})
	end

	v20.FtuxOverlay = ftuxOverlay
	return createElement(View, {
		backgroundStyle = FFlagMomentsRenderAvatarPostsInFeed and { Transparency = 1 } or nil,
		tag = {
			["size-full"] = FFlagMomentsRenderAvatarPostsInFeed,
			["size-full bg-surface-0"] = not FFlagMomentsRenderAvatarPostsInFeed
		}
	}, v20)
end

return TrendingScreen
