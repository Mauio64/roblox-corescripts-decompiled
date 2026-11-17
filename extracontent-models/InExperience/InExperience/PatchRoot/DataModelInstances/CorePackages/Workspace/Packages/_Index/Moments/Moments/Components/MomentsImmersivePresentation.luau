local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local Navigation = require(parent.Navigation)
local RoactNavigation = require(parent.RoactNavigation)
local SharedFlags = require(parent.SharedFlags)
local SignalsReact = require(parent.SignalsReact)

local MomentsCommon = require(parent.MomentsCommon)
local isStudio = require(parent.MomentsCommon.isStudio)
local Constants = require(Moments.Constants)
local ImmersiveFeedKind = Constants.ImmersiveFeedKind

local MomentsHostShell = require(Moments.Components.MomentsHostShell)
require(Moments.MomentsHostContext)
local MomentsFeedSurface = require(Moments.Components.MomentsFeedSurface)
local MomentsBackHeader = require(Moments.Components.MomentsBackHeader)
local MomentsCreation = require(parent.MomentsCreation)
local CreationFlowScreen = MomentsCreation.CreationFlowScreen
local FTUXEducationScreen = require(Moments.Components.FTUXEducationScreen)
local Feed = require(Moments.Components.Feed)
local MomentPushedFeedSafeAreaContext = require(Moments.Components.Feed.Items.Moment.MomentPushedFeedSafeAreaContext)
local createMomentsStore = require(Moments.Stores.GetMomentsStore.createMomentsStore)
local createMomentsFeedSource = require(Moments.Stores.GetMomentsStore.createMomentsFeedSource)
local GetDeepLinkStore = require(Moments.Stores.GetDeepLinkStore)
local createUserMomentsFeedSource = require(Moments.Stores.GetMomentsStore.createUserMomentsFeedSource)
local GetMomentsPreferencesStore = require(Moments.Stores.GetMomentsPreferencesStore)
local useCreationEntry = require(Moments.Hooks.useCreationEntry)
local useUploadHost = require(Moments.Hooks.useUploadHost)
local logCreateIntent = require(Moments.Analytics.logCreateIntent)
local logMomentsLayerExposure = MomentsCommon.Utils.logMomentsLayerExposure
local FFlagMomentsCreateAvatarPosts = SharedFlags.FFlagMomentsCreateAvatarPosts
local FFlagMomentsFlushDwellBeforeNavigation = require(Moments.Flags.FFlagMomentsFlushDwellBeforeNavigation)
local NavigationDestinationType = require(Moments.Enums.NavigationDestinationType)
local MomentsFeedType = require(Moments.Enums.MomentsFeedType)
local FFlagMomentsNavigationEvent = require(Moments.Flags.FFlagMomentsNavigationEvent)

local FFlagMomentsPersonalizedRecommendationsEntryPoint = require(Moments.Flags.FFlagMomentsPersonalizedRecommendationsEntryPoint)
local defineFastFlag = game:DefineFastFlag("MomentsImmersiveNavigationMenu", false)
local FFlagMomentsRenderAvatarPostsInFeed = SharedFlags.FFlagMomentsRenderAvatarPostsInFeed

local FStringMomentsExperienceJoinActionTextIxpLayer = require(Moments.Flags.FStringMomentsExperienceJoinActionTextIxpLayer)
local GetFFlagArgusStudioMockFeed = require(Moments.Flags.GetFFlagArgusStudioMockFeed)
local SignalTracker = require(Moments.SignalTracker)
local createSignalTracker = SignalTracker.createSignalTracker

local View = Foundation.View

local useNavigationFocus = Navigation.useNavigationFocus
local useNavigation = Navigation.useNavigation
local useSignalState = SignalsReact.useSignalState
local FFlagEnableArgus = SharedFlags.FFlagEnableArgus
local FFlagMomentsCreationFeatureGate = SharedFlags.FFlagMomentsCreationFeatureGate
local FFlagMomentsOptimisticProfilePending = SharedFlags.FFlagMomentsOptimisticProfilePending
local FFlagMomentsAvatarLookTryOn = SharedFlags.FFlagMomentsAvatarLookTryOn

local Analytics = MomentsCommon.Analytics
local EventNames = Analytics.EventNames
local FunnelEventNames = Analytics.FunnelEventNames
local fireAnalyticsEvent = Analytics.fireAnalyticsEvent
local feedPlaybackSuspension = MomentsCommon.Media.feedPlaybackSuspension
local reportModalCovering = MomentsCommon.Media.reportModalCovering
local accountSettingsCovering = require(Moments.Components.Feed.accountSettingsCovering)
local useDeviceInsets = MomentsCommon.Hooks.useDeviceInsets
local useMomentsGating = MomentsCommon.Hooks.useMomentsGating

local createRecommendationTelemetry = Feed.createRecommendationTelemetry
local createMockFeedSource = Feed.createMockFeedSource

local function PushedFeedSafeAreaProvider(p)
	local v = useDeviceInsets()

	return React.createElement(MomentPushedFeedSafeAreaContext.Context.Provider, { value = v }, {
		Content = p.children
	})
end

local function MomentsImmersivePresentation(props)
	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)

	if ref2.current == nil then
		ref2.current = createMomentsStore()
	end

	local current = ref2.current

	local ref3 = React.useRef(nil)

	if ref3.current == nil and FFlagEnableArgus then
		ref3.current = createSignalTracker()
	end

	local current2 = ref3.current

	local feedKind = props.feedKind
	local targetUserId = props.targetUserId
	local initialIndex = props.initialIndex
	local initialMomentId

	if FFlagMomentsOptimisticProfilePending then
		initialMomentId = props.initialMomentId
	else
		initialMomentId = nil
	end

	local v = useCreationEntry({ manageTabBarVisibility = false })

	local host = useUploadHost({ onExit = v.onExitCreation, captureSource = v.captureSource })
	local onCreatePressed

	if v == nil then
		onCreatePressed = nil
	else
		onCreatePressed = v.onCreatePressed
	end

	local v2 = React.useCallback(function()
		if onCreatePressed ~= nil then
			logCreateIntent(FunnelEventNames.CreationIntentSource.TopBar)
			onCreatePressed()
		end
	end, { onCreatePressed })
	local isCreationEnabled

	if FFlagMomentsCreationFeatureGate then
		isCreationEnabled = useMomentsGating().isCreationEnabled
	end

	local v3

	if feedKind == ImmersiveFeedKind.Trending then
		v3 = not FFlagMomentsCreationFeatureGate or isCreationEnabled
	else
		v3 = false
	end

	local v4

	if v3 then
		v4 = not (v == nil) and v.isCreating
	else
		v4 = v3
	end

	local v5

	if v3 then
		v5 = not (v == nil) and v.showFtux
	else
		v5 = v3
	end

	local deepLinkedMomentId = props.deepLinkedMomentId
	local deepLinkedMomentTargetIdType = props.deepLinkedMomentTargetIdType
	local ref4 = React.useRef(nil)

	if deepLinkedMomentId ~= nil then
		local formatted = `{deepLinkedMomentId}:{tostring(deepLinkedMomentTargetIdType)}`

		if ref4.current ~= formatted then
			GetDeepLinkStore().setDeepLinkedMoment(deepLinkedMomentId, deepLinkedMomentTargetIdType)
			ref4.current = formatted
		end
	end

	local source = React.useMemo(function()
		if feedKind == ImmersiveFeedKind.User then
			return createUserMomentsFeedSource(targetUserId or 0, {
				initialIndex = initialIndex,
				initialMomentId = initialMomentId
			})
		end

		if isStudio() and GetFFlagArgusStudioMockFeed() then
			return createMockFeedSource()
		end

		return createMomentsFeedSource(current.getMomentsSessionId, { signalTracker = current2 })
	end, { feedKind, targetUserId, initialIndex, initialMomentId, current, current2 })

	local telemetry = React.useMemo(function()
		if feedKind == ImmersiveFeedKind.Trending and FFlagEnableArgus then
			return createRecommendationTelemetry({
				getMomentsSessionId = current.getMomentsSessionId,
				signalTracker = current2,
				feedType = MomentsFeedType.Trending
			})
		end

		return nil
	end, { feedKind, current, current2 })

	local sessionSource = props.sessionSource
	React.useEffect(function()
		current.setSessionSource(sessionSource)
		logMomentsLayerExposure(FStringMomentsExperienceJoinActionTextIxpLayer)
		local FFlagMomentsCreatorAttributionIxpEnabled = require(Moments.Flags.FFlagMomentsCreatorAttributionIxpEnabled)

		if FFlagMomentsCreatorAttributionIxpEnabled then
			logMomentsLayerExposure(require(Moments.Flags.FStringMomentsCreatorAttributionIxpLayer))
		end

		local FFlagMomentsFeedIxpEnabled = require(Moments.Flags.FFlagMomentsFeedIxpEnabled)

		if FFlagMomentsFeedIxpEnabled then
			logMomentsLayerExposure(require(Moments.Flags.FStringMomentsFeedIxpLayer))
		end

		fireAnalyticsEvent(EventNames.TapMomentsTab, {
			moments_session_id = current.getMomentsSessionId(false),
			source = sessionSource
		})

		Analytics.reportMomentsSessionStarted(sessionSource)
		local momentsSessionHeartbeat = Analytics.createMomentsSessionHeartbeat()

		if momentsSessionHeartbeat ~= nil then
			momentsSessionHeartbeat.start(sessionSource)
		end

		return function()
			if momentsSessionHeartbeat ~= nil then
				momentsSessionHeartbeat.stop()
			end

			local v6 = os.clock() - current.getSessionStartTime(false)

			fireAnalyticsEvent(EventNames.MomentsSessionEnded, {
				moments_session_id = current.getMomentsSessionId(false),
				source = sessionSource,
				duration_seconds = tostring((math.floor(v6)))
			})

			Analytics.reportMomentsSessionEnded(sessionSource)
		end
	end, { sessionSource, current })

	local v6 = useNavigationFocus()

	local v7 = useSignalState(feedPlaybackSuspension.getSuspended)
	local v8 = useSignalState(GetMomentsPreferencesStore(false).getIsTeleporting)

	local v9 = useSignalState(reportModalCovering.getCovering)
	local v10

	if FFlagMomentsPersonalizedRecommendationsEntryPoint then
		v10 = useSignalState(accountSettingsCovering.getCovering)
	else
		v10 = false
	end

	local v11 = React.useCallback(function(p)
		local current3 = ref.current

		if current3 ~= nil then
			current3.flushView(p)
		end
	end, {})
	local v12

	if FFlagMomentsCreateAvatarPosts then
		v12 = React.useCallback(function()
			logCreateIntent(FunnelEventNames.CreationIntentSource.TopBar)

			if FFlagMomentsNavigationEvent then
				v11(NavigationDestinationType.Create)
			end

			if props.openAvatarMomentsCreation ~= nil then
				props.openAvatarMomentsCreation()
			end
		end, { v11, props.openAvatarMomentsCreation })
	else
		v12 = nil
	end

	if not FFlagMomentsCreateAvatarPosts or props.openAvatarMomentsCreation == nil then
		v12 = nil
	end

	local v13 = React.useCallback(function(p)
		local current3 = ref.current

		if current3 ~= nil then
			current3.refresh(p)
		end
	end, {})
	local v14

	if FFlagMomentsFlushDwellBeforeNavigation then
		v14 = useNavigation()
	else
		v14 = nil
	end

	React.useEffect(function()
		if not FFlagMomentsFlushDwellBeforeNavigation or v14 == nil or v14.addListener == nil then
			return nil
		end

		local v15 = v14.addListener(RoactNavigation.Events.WillBlur, function()
			v11()
		end)
		return function()
			v15.remove()
		end
	end, { v14, v11 })

	local onBack = props.onBack
	local onBack2 = React.useCallback(function()
		if FFlagMomentsFlushDwellBeforeNavigation then
			local v15

			if FFlagMomentsNavigationEvent then
				v15 = NavigationDestinationType.Exit
			end

			v11(v15)
		end

		onBack()
	end, { onBack, v11 })
	local v15 = React.useCallback(function()
		fireAnalyticsEvent(EventNames.FeedHomeButtonPressed)
		local v15

		if FFlagMomentsNavigationEvent then
			v15 = NavigationDestinationType.Trending
		end

		v13(v15)
	end, { v13 })
	local openOwnMoments = props.openOwnMoments
	local v16 = React.useCallback(function()
		fireAnalyticsEvent(EventNames.MyCreationButtonPressed)

		if openOwnMoments ~= nil then
			if FFlagMomentsFlushDwellBeforeNavigation then
				local v16

				if FFlagMomentsNavigationEvent then
					v16 = NavigationDestinationType.MyMoments
				end

				v11(v16)
			end

			openOwnMoments()
		end
	end, { openOwnMoments, v11 })
	local v17 = defineFastFlag and feedKind == ImmersiveFeedKind.Trending
	local useMemo = React.useMemo
	local function fn()
		local createElement = React.createElement
		local v18 = {
			onBack = onBack2,
			onCreatePressed = nil,
			onCreateAvatarMomentPressed = nil,
			onNavigateToTrending = nil,
			onNavigateToMyMoments = nil
		}
		local onCreatePressed2

		if v3 then
			onCreatePressed2 = v2
		end

		v18.onCreatePressed = onCreatePressed2
		local onCreateAvatarMomentPressed

		if FFlagMomentsCreateAvatarPosts then
			onCreateAvatarMomentPressed = v12
		end

		v18.onCreateAvatarMomentPressed = onCreateAvatarMomentPressed
		local onNavigateToTrending

		if v17 then
			onNavigateToTrending = v15
		end

		v18.onNavigateToTrending = onNavigateToTrending
		local onNavigateToMyMoments

		if v17 then
			onNavigateToMyMoments = v16
		end

		v18.onNavigateToMyMoments = onNavigateToMyMoments
		return createElement(MomentsBackHeader, v18)
	end

	local v18

	if FFlagMomentsCreateAvatarPosts then
		v18 = v12
	end

	local header = useMemo(fn, { onBack2, v3, v2, v18, v17, v15, v16 })
	local inactiveDestination

	if FFlagMomentsNavigationEvent then
		if v4 then
			inactiveDestination = NavigationDestinationType.Create
		elseif v9 then
			inactiveDestination = NavigationDestinationType.Report
		end
	end

	local element = React.createElement(MomentsFeedSurface, {
		source = source,
		telemetry = telemetry,
		inactiveDestination = inactiveDestination,
		active = v6 and not v9 and not (v4 or v10),
		playbackActive = v6 and not v7 and not (v8 or v9) and not (v4 or v10),
		initialIndex = initialIndex,
		header = header,
		controllerRef = ref
	})

	local feed = React.createElement(PushedFeedSafeAreaProvider, nil, element)

	if v3 then
		local createElement = React.createElement
		local creationFlowOverlay

		if v4 then
			creationFlowOverlay = React.createElement(
				View,
				{ tag = "size-full", ZIndex = Constants.DisplayOrder.Modals },
				{
					Screen = React.createElement(CreationFlowScreen, { host = host })
				}
			)
		end

		local ftuxOverlay

		if v5 then
			ftuxOverlay = React.createElement(View, {
				tag = "size-full",
				ZIndex = Constants.DisplayOrder.Modals
			}, {
				Screen = React.createElement(FTUXEducationScreen, { onClose = v.onExitFtux })
			})
		end

		feed = createElement(View, {
			backgroundStyle = FFlagMomentsRenderAvatarPostsInFeed and { Transparency = 1 } or nil,
			tag = {
				["size-full"] = FFlagMomentsRenderAvatarPostsInFeed,
				["size-full bg-surface-0"] = not FFlagMomentsRenderAvatarPostsInFeed
			}
		}, { Feed = feed, CreationFlowOverlay = creationFlowOverlay, FtuxOverlay = ftuxOverlay })
	end

	local createElement = React.createElement
	local v19 = {
		sessionStore = current,
		openProfile = props.openProfile,
		openOwnMoments = props.openOwnMoments,
		openMomentsFeedReport = props.openMomentsFeedReport,
		openAvatarLookTryOn = 0,
		openMomentCommentReport = 0,
		openBlockUser = 0
	}
	local openAvatarLookTryOn

	if FFlagMomentsAvatarLookTryOn then
		openAvatarLookTryOn = props.openAvatarLookTryOn
	end

	v19.openAvatarLookTryOn = openAvatarLookTryOn
	v19.openMomentCommentReport = props.openMomentCommentReport
	v19.openBlockUser = props.openBlockUser
	return createElement(MomentsHostShell, v19, feed)
end

return React.memo(MomentsImmersivePresentation)
