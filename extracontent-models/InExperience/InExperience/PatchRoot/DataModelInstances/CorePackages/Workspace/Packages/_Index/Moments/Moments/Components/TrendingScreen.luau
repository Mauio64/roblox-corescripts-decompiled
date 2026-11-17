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

local FFlagMomentsPersonalizedRecommendationsEntryPoint = require(Moments.Flags.FFlagMomentsPersonalizedRecommendationsEntryPoint)
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
local FFlagMomentsRecommendationFeedType = require(Moments.Flags.FFlagMomentsRecommendationFeedType)
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
local FFlagMomentsCreateAvatarPosts = SharedFlags.FFlagMomentsCreateAvatarPosts
local FFlagEnableArgus = SharedFlags.FFlagEnableArgus
local FFlagMomentsCreationFeatureGate = SharedFlags.FFlagMomentsCreationFeatureGate
local FFlagMomentsRenderAvatarPostsInFeed = SharedFlags.FFlagMomentsRenderAvatarPostsInFeed
local FFlagMomentsPostFeedback = SharedFlags.FFlagMomentsPostFeedback
local FFlagMomentsPostFeedbackIxpEnabled = require(Moments.Flags.FFlagMomentsPostFeedbackIxpEnabled)
local isStudio = require(parent.MomentsCommon.isStudio)
local MomentsCommon = require(parent.MomentsCommon)
local reportModalCovering = MomentsCommon.Media.reportModalCovering
local accountSettingsCovering = require(Moments.Components.Feed.accountSettingsCovering)
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

	local v7 = useMomentsHost()
	local openOwnMoments = v7.openOwnMoments
	local openAvatarMomentsCreation

	if FFlagMomentsCreateAvatarPosts then
		openAvatarMomentsCreation = v7.openAvatarMomentsCreation
	else
		openAvatarMomentsCreation = nil
	end

	local v8 = useMomentsGating()
	local platformIntegrationEnabled = v8.isFlyoutEntryEnabled and v8.platformIntegrationEnabled
	local v9

	if FFlagMomentsCreationFeatureGate then
		v9 = not (v8 == nil) and v8.isCreationEnabled
	else
		v9 = nil
	end

	local v10 = useCreationEntry()

	local host = useUploadHost({
		onExit = v10.onExitCreation,
		captureSource = v10.captureSource,
		postFeedback = FFlagMomentsPostFeedback and true or nil,
		logsPostFeedbackExposure = FFlagMomentsPostFeedbackIxpEnabled and true or nil
	})

	React.useEffect(function()
		local v11 = SessionManager.getSessionId(FunnelEventNames.FunnelTypes.AppNavigation)
			or SessionManager.startSession(FunnelEventNames.FunnelTypes.AppNavigation)
		fireFunnelAnalyticsEvent(
			FunnelEventNames.FunnelTypes.AppNavigation,
			FunnelEventNames.AppNavigationSteps.TrendingScreenView,
			v11
		)
	end, {})

	local onDeepLinkedMomentUnavailable = React.useCallback(function()
		setState2(true)
	end, {})

	local v11 = React.useMemo(function()
		if isStudio() and GetFFlagArgusStudioMockFeed() then
			return createMockFeedSource()
		end

		return createMomentsFeedSource(v6.getMomentsSessionId, {
			signalTracker = signalTracker,
			onDeepLinkedMomentUnavailable = onDeepLinkedMomentUnavailable
		})
	end, { v6, onDeepLinkedMomentUnavailable })

	local v12 = React.useMemo(function()
		if not FFlagEnableArgus then
			return nil
		end

		local v12 = {
			getMomentsSessionId = v6.getMomentsSessionId,
			signalTracker = signalTracker,
			feedType = 0
		}
		local feedType

		if FFlagMomentsRecommendationFeedType then
			feedType = MomentsFeedType.Trending
		end

		v12.feedType = feedType
		return createRecommendationTelemetry(v12)
	end, { v6 })
	local followingTelemetry

	if FFlagMomentsRecommendationFeedType and FFlagMomentsFollowingFeed then
		followingTelemetry = React.useMemo(function()
			if FFlagEnableArgus then
				return createRecommendationTelemetry({
					getMomentsSessionId = v6.getMomentsSessionId,
					signalTracker = signalTracker,
					feedType = MomentsFeedType.Following
				})
			end

			return nil
		end, { v6 })
	end

	local v13 = SignalsReact.useSignalState(GetImmersiveChromeStore(false).getOverlayCovering)

	local v14 = SignalsReact.useSignalState(reportModalCovering.getCovering)
	local v15

	if FFlagMomentsPersonalizedRecommendationsEntryPoint then
		v15 = SignalsReact.useSignalState(accountSettingsCovering.getCovering)
	else
		v15 = false
	end

	local active = not (v10.isCreating or v13 or state2 or v14 or v15)

	if FFlagMomentsFixRecommendationImpressionLifecycle then
		active = active and v3
	end

	local playbackActive = v3 and not (v10.isCreating or state2) and not (v14 or v15)
	local inactiveDestination

	if FFlagMomentsNavigationEvent then
		if v5 then
			inactiveDestination = NavigationDestinationType.ExperienceJoin
		elseif v10.isCreating then
			inactiveDestination = NavigationDestinationType.Create
		elseif v14 then
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
	local v16

	if FFlagMomentsCreateAvatarPosts then
		v16 = React.useCallback(function()
			logCreateIntent(FunnelEventNames.CreationIntentSource.TopBar)

			if FFlagMomentsNavigationEvent then
				flushView(NavigationDestinationType.Create)
			end

			if openAvatarMomentsCreation ~= nil then
				openAvatarMomentsCreation()
			end
		end, { flushView, openAvatarMomentsCreation })
	else
		v16 = nil
	end

	if not FFlagMomentsCreateAvatarPosts or openAvatarMomentsCreation == nil then
		v16 = nil
	end

	local v17

	if useFeedSelection == nil then
		v17 = nil
	else
		if not FFlagMomentsRecommendationFeedType then
			followingTelemetry = nil
		end

		v17 = useFeedSelection({
			trendingSource = v11,
			trendingTelemetry = v12,
			followingTelemetry = followingTelemetry,
			refreshFeed = refreshFeed,
			flushView = flushView
		})
	end

	if v17 ~= nil then
		v11 = v17.source
	end

	if v17 ~= nil then
		v12 = v17.telemetry
	end

	React.useEffect(function()
		if not FFlagMomentsFlushDwellBeforeNavigation or p.navigation.addListener == nil then
			return nil
		end

		local v18 = p.navigation.addListener(RoactNavigation.Events.WillBlur, function()
			flushView()
		end)
		return function()
			v18.remove()
		end
	end, { p.navigation, flushView })

	React.useEffect(function()
		local reloadPageConnection = RobloxAppEvents.ReloadPage:connect(function(p2)
			if p2 == AppPage.Moments then
				if v17 == nil or v17.getSelected() ~= MomentsFeedType.Following then
					refreshFeed()
				else
					v17.select(MomentsFeedType.Trending)
				end
			end
		end)

		return function()
			reloadPageConnection:disconnect()
		end
	end, { refreshFeed, v17 })

	local uploadStore = GetUploadStore(false)
	local current2 = SignalsReact.useSignalState(uploadStore.getState)
	local v18 = SignalsReact.useSignalState(uploadStore.getUploadedMoment)
	React.useEffect(function()
		if current2 ~= "Success" then
			ref2.current = current2
		elseif ref2.current ~= "Success" then
			ref2.current = current2

			if v17 == nil or v17.getSelected() ~= MomentsFeedType.Following then
				local current = ref.current

				if type(v18) == "table" and v18.momentId ~= nil and current ~= nil then
					getUploadLogger():debug( -- inferred equivalent call
						"event=feed_prepend_uploaded momentId={} assetId={}",
						v18.momentId,
						(tostring(v18.assetId))
					)

					current.prependMoment(v18)
				else
					getUploadLogger():debug( -- inferred equivalent call
						"event=feed_refresh_after_upload uploadedMoment={} hasController={}",
						tostring(v18),
						(tostring(current ~= nil))
					)

					refreshFeed()
				end
			else
				getUploadLogger():debug("event=feed_upload_skipped_on_following") -- inferred equivalent call
			end
		end
	end, { current2, v18, refreshFeed, v17 })

	local onFtuxTooltipDismissed = React.useCallback(function()
		setState(false)
		MomentsLocalStorage.setField(MomentsLocalStorageKeys.CreateTooltipSeen, true)
	end, {})

	local v19 = React.useCallback(function()
		logCreateIntent(FunnelEventNames.CreationIntentSource.TopBar)
		v10.onCreatePressed()
	end, { v10.onCreatePressed })

	local onNavigateToTrending = React.useCallback(function()
		fireAnalyticsEvent(EventNames.FeedHomeButtonPressed)

		if v17 ~= nil then
			v17.select(MomentsFeedType.Trending)
			return
		end

		local v20

		if FFlagMomentsNavigationEvent then
			v20 = NavigationDestinationType.Trending
		end

		refreshFeed(v20)
	end, { refreshFeed, v17 })

	local onNavigateToMyMoments = React.useCallback(function()
		fireAnalyticsEvent(EventNames.MyCreationButtonPressed)

		if openOwnMoments ~= nil then
			if FFlagMomentsFlushDwellBeforeNavigation then
				local v20

				if FFlagMomentsNavigationEvent then
					v20 = NavigationDestinationType.MyMoments
				end

				flushView(v20)
			end

			openOwnMoments()
		end
	end, { openOwnMoments, flushView })

	local v20 = React.useCallback(function(p2)
		if p2 == MomentsFeedType.Trending then
			onNavigateToTrending()
		elseif v17 ~= nil then
			v17.select(p2)
		end
	end, { onNavigateToTrending, v17 })

	local useMemo = React.useMemo
	local function fn()
		local createElement = React.createElement
		local v21 = {
			isBaseScreen = true,
			showTopScrim = true,
			showFtuxTooltip = state and v3 and (not FFlagMomentsCreationFeatureGate or v9),
			showHamburger = platformIntegrationEnabled,
			onFtuxTooltipDismissed = onFtuxTooltipDismissed,
			onCreatePressed = nil,
			onCreateAvatarMomentPressed = nil,
			onNavigateToTrending = nil,
			onNavigateToMyMoments = nil,
			selectedFeedType = 0,
			onFeedTypeSelected = 0
		}
		local onCreatePressed

		if not (FFlagMomentsCreationFeatureGate and not v9) then
			onCreatePressed = v19
		end

		v21.onCreatePressed = onCreatePressed
		local onCreateAvatarMomentPressed

		if FFlagMomentsCreateAvatarPosts then
			onCreateAvatarMomentPressed = v16
		end

		v21.onCreateAvatarMomentPressed = onCreateAvatarMomentPressed

		v21.onNavigateToTrending = onNavigateToTrending
		v21.onNavigateToMyMoments = onNavigateToMyMoments
		local selectedFeedType

		if v17 ~= nil then
			selectedFeedType = v17.selected
		end

		v21.selectedFeedType = selectedFeedType
		local onFeedTypeSelected

		if v17 ~= nil then
			onFeedTypeSelected = v20
		end

		v21.onFeedTypeSelected = onFeedTypeSelected
		return createElement(TopBar, v21)
	end

	local v21 = if FFlagMomentsCreationFeatureGate then v9 else false
	local v22

	if FFlagMomentsCreateAvatarPosts then
		v22 = v16
	end

	local header = useMemo(fn, {
		state,
		v3,
		v21,
		platformIntegrationEnabled,
		onFtuxTooltipDismissed,
		v19,
		v22,
		onNavigateToTrending,
		onNavigateToMyMoments,
		v20,
		v17
	})
	local v23

	if FFlagMomentsFixFeedForDeviceSafeInsets then
		local v24 = MomentsCommon2.Hooks.useDeviceInsets()
		v23 = not shouldUseDeviceSafeInsets and 0 or v24.top
	else
		v23 = 0
	end

	local renderFeedContainer = React.useCallback(function(feed)
		local element = React.createElement(MomentOverlayInsetContext.Context.Provider, {
			value = v2
		}, { Feed = feed })

		local padding = FFlagMomentsFeedAboveNavBar and { bottom = UDim.new(0, v2) } or nil

		local createElement = React.createElement
		local v24 = {
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
			position = UDim2.fromOffset(0, -v23)
		end

		v24.Position = position
		local size

		if v then
			size = UDim2.new(1, 0, 1, v23)
		end

		v24.Size = size

		v24.padding = padding
		v24.ZIndex = Constants.DisplayOrder.Feed
		local switchFade

		if not (FeedSwitchFade == nil or v17 == nil) then
			switchFade = React.createElement(FeedSwitchFade, { feedKey = v17.selected, ZIndex = 2 })
		end

		return createElement(View, v24, { Feed = element, SwitchFade = switchFade })
	end, { v2, v23, v17 })

	local createElement = React.createElement

	local createElement2 = React.createElement
	local v24 = {
		source = v11,
		active = active,
		playbackActive = playbackActive,
		telemetry = v12,
		inactiveDestination = inactiveDestination,
		controllerRef = ref,
		trackSurfaceLoad = true,
		header = header,
		renderFeedContainer = renderFeedContainer,
		emptyState = 0,
		caughtUpState = 0
	}
	local emptyState

	if v17 ~= nil then
		emptyState = v17.emptyState
	end

	v24.emptyState = emptyState
	local caughtUpState

	if v17 ~= nil then
		caughtUpState = v17.caughtUpState
	end

	v24.caughtUpState = caughtUpState
	local v25 = {
		Surface = createElement2(MomentsFeedSurface, v24),
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

	v25.MomentUnavailableDialog = momentUnavailableDialog
	local creationFlowOverlay

	if v10.isCreating then
		creationFlowOverlay = React.createElement(View, {
			tag = "size-full",
			ZIndex = Constants.DisplayOrder.Modals
		}, {
			Screen = React.createElement(CreationFlowScreen, { host = host })
		})
	end

	v25.CreationFlowOverlay = creationFlowOverlay
	local ftuxOverlay

	if v10.showFtux then
		ftuxOverlay = React.createElement(View, {
			tag = "size-full",
			ZIndex = Constants.DisplayOrder.Modals
		}, {
			Screen = React.createElement(FTUXEducationScreen, { onClose = v10.onExitFtux })
		})
	end

	v25.FtuxOverlay = ftuxOverlay
	return createElement(View, {
		backgroundStyle = FFlagMomentsRenderAvatarPostsInFeed and { Transparency = 1 } or nil,
		tag = {
			["size-full"] = FFlagMomentsRenderAvatarPostsInFeed,
			["size-full bg-surface-0"] = not FFlagMomentsRenderAvatarPostsInFeed
		}
	}, v25)
end

return TrendingScreen
