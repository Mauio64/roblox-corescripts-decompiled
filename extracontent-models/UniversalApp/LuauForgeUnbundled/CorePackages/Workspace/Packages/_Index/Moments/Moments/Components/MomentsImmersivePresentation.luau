local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")
local Navigation = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Navigation")
local RoactNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/RoactNavigation")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SharedFlags")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SignalsReact")

local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/MomentsCommon")
local isStudio = require("@game/CorePackages/Workspace/Packages/_Index/Moments/MomentsCommon/isStudio")
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Constants")
local immersiveFeedKind = Constants.ImmersiveFeedKind

local MomentsHostShell = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/MomentsHostShell")
require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/MomentsHostContext")
local MomentsFeedSurface = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/MomentsFeedSurface")
local MomentsBackHeader = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/MomentsBackHeader")
local creationFlowScreen = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/MomentsCreation").CreationFlowScreen
local FTUXEducationScreen = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/FTUXEducationScreen")
local module14 = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed")
local MomentPushedFeedSafeAreaContext = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/Moment/MomentPushedFeedSafeAreaContext")
local createMomentsStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetMomentsStore/createMomentsStore")
local createMomentsFeedSource = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetMomentsStore/createMomentsFeedSource")
local GetDeepLinkStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetDeepLinkStore")
local createUserMomentsFeedSource = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetMomentsStore/createUserMomentsFeedSource")
local GetMomentsPreferencesStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetMomentsPreferencesStore")
local useCreationEntry = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Hooks/useCreationEntry")
local useUploadHost = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Hooks/useUploadHost")
local logCreateIntent = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Analytics/logCreateIntent")
local logMomentsLayerExposure = MomentsCommon.Utils.logMomentsLayerExposure
local fFlagMomentsCreateAvatarPosts = SharedFlags.FFlagMomentsCreateAvatarPosts
local FFlagMomentsFlushDwellBeforeNavigation = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsFlushDwellBeforeNavigation")
local NavigationDestinationType = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Enums/NavigationDestinationType")
local MomentsFeedType = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Enums/MomentsFeedType")
local FFlagMomentsNavigationEvent = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsNavigationEvent")

local FFlagMomentsPersonalizedRecommendationsEntryPoint = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsPersonalizedRecommendationsEntryPoint")
local defineFastFlag = game:DefineFastFlag("MomentsImmersiveNavigationMenu", false)
local fFlagMomentsRenderAvatarPostsInFeed = SharedFlags.FFlagMomentsRenderAvatarPostsInFeed

local FStringMomentsExperienceJoinActionTextIxpLayer = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FStringMomentsExperienceJoinActionTextIxpLayer")
local GetFFlagArgusStudioMockFeed = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/GetFFlagArgusStudioMockFeed")
local createSignalTracker = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/SignalTracker").createSignalTracker

local view = Foundation.View

local useNavigationFocus = Navigation.useNavigationFocus
local useNavigation = Navigation.useNavigation
local useSignalState = SignalsReact.useSignalState
local fFlagEnableArgus = SharedFlags.FFlagEnableArgus
local fFlagMomentsCreationFeatureGate = SharedFlags.FFlagMomentsCreationFeatureGate
local fFlagMomentsOptimisticProfilePending = SharedFlags.FFlagMomentsOptimisticProfilePending
local fFlagMomentsAvatarLookTryOn = SharedFlags.FFlagMomentsAvatarLookTryOn

local analytics = MomentsCommon.Analytics
local eventNames = analytics.EventNames
local funnelEventNames = analytics.FunnelEventNames
local fireAnalyticsEvent = analytics.fireAnalyticsEvent
local feedPlaybackSuspension = MomentsCommon.Media.feedPlaybackSuspension
local reportModalCovering = MomentsCommon.Media.reportModalCovering
local accountSettingsCovering = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/accountSettingsCovering")
local useDeviceInsets = MomentsCommon.Hooks.useDeviceInsets
local useMomentsGating = MomentsCommon.Hooks.useMomentsGating

local createRecommendationTelemetry = module14.createRecommendationTelemetry
local createMockFeedSource = module14.createMockFeedSource

local function PushedFeedSafeAreaProvider(p2)
	local v5 = useDeviceInsets()

	return React.createElement(MomentPushedFeedSafeAreaContext.Context.Provider, { value = v5 }, {
		Content = p2.children
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

	if ref3.current == nil and fFlagEnableArgus then
		ref3.current = createSignalTracker()
	end

	local current2 = ref3.current

	local feedKind = props.feedKind
	local targetUserId = props.targetUserId
	local initialIndex = props.initialIndex
	local initialMomentId = if fFlagMomentsOptimisticProfilePending then props.initialMomentId else nil

	local v5 = useCreationEntry({ manageTabBarVisibility = false })

	local v6 = useUploadHost({ onExit = v5.onExitCreation, captureSource = v5.captureSource })

	local onCreatePressed = if v5 ~= nil then v5.onCreatePressed else nil
	local v7 = React.useCallback(function()
		if onCreatePressed ~= nil then
			logCreateIntent(funnelEventNames.CreationIntentSource.TopBar)
			onCreatePressed()
		end
	end, { onCreatePressed })

	local isCreationEnabled = if fFlagMomentsCreationFeatureGate then useMomentsGating().isCreationEnabled else nil
	local v8

	if feedKind == immersiveFeedKind.Trending then
		v8 = not fFlagMomentsCreationFeatureGate or isCreationEnabled
	else
		v8 = false
	end

	local v9 = if v8 then not (v5 == nil) and v5.isCreating else v8
	local v10 = if v8 then not (v5 == nil) and v5.showFtux else v8

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

	local v11 = React.useMemo(function()
		if feedKind == immersiveFeedKind.User then
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

	local v12 = React.useMemo(function()
		if feedKind == immersiveFeedKind.Trending and fFlagEnableArgus then
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

		if require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsCreatorAttributionIxpEnabled") then
			logMomentsLayerExposure(require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FStringMomentsCreatorAttributionIxpLayer"))
		end

		if require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsFeedIxpEnabled") then
			logMomentsLayerExposure(require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FStringMomentsFeedIxpLayer"))
		end

		fireAnalyticsEvent(eventNames.TapMomentsTab, {
			moments_session_id = current.getMomentsSessionId(false),
			source = sessionSource
		})

		analytics.reportMomentsSessionStarted(sessionSource)
		local momentsSessionHeartbeat = analytics.createMomentsSessionHeartbeat()

		if momentsSessionHeartbeat ~= nil then
			momentsSessionHeartbeat.start(sessionSource)
		end

		return function()
			if momentsSessionHeartbeat ~= nil then
				momentsSessionHeartbeat.stop()
			end

			local v13 = os.clock() - current.getSessionStartTime(false)

			fireAnalyticsEvent(eventNames.MomentsSessionEnded, {
				moments_session_id = current.getMomentsSessionId(false),
				source = sessionSource,
				duration_seconds = tostring((math.floor(v13)))
			})

			analytics.reportMomentsSessionEnded(sessionSource)
		end
	end, { sessionSource, current })

	local v13 = useNavigationFocus()

	local v14 = useSignalState(feedPlaybackSuspension.getSuspended)
	local v15 = useSignalState(GetMomentsPreferencesStore(false).getIsTeleporting)

	local v16 = useSignalState(reportModalCovering.getCovering)

	local v17 = if FFlagMomentsPersonalizedRecommendationsEntryPoint then useSignalState(accountSettingsCovering.getCovering) else false

	local v19 = React.useCallback(function(p2)
		local current3 = ref.current

		if current3 ~= nil then
			current3.flushView(p2)
		end
	end, {})
	local v20

	if fFlagMomentsCreateAvatarPosts then
		v20 = React.useCallback(function()
			logCreateIntent(funnelEventNames.CreationIntentSource.TopBar)

			if FFlagMomentsNavigationEvent then
				v19(NavigationDestinationType.Create)
			end

			if props.openAvatarMomentsCreation ~= nil then
				props.openAvatarMomentsCreation()
			end
		end, { v19, props.openAvatarMomentsCreation })
	else
		v20 = nil
	end

	if not fFlagMomentsCreateAvatarPosts or props.openAvatarMomentsCreation == nil then
		v20 = nil
	end

	local v21 = React.useCallback(function(p2)
		local current3 = ref.current

		if current3 ~= nil then
			current3.refresh(p2)
		end
	end, {})

	local v22 = if FFlagMomentsFlushDwellBeforeNavigation then useNavigation() else nil

	React.useEffect(function()
		if not FFlagMomentsFlushDwellBeforeNavigation or v22 == nil or v22.addListener == nil then
			return nil
		end

		local v23 = v22.addListener(RoactNavigation.Events.WillBlur, function()
			v19()
		end)
		return function()
			v23.remove()
		end
	end, { v22, v19 })

	local onBack = props.onBack
	local v23 = React.useCallback(function()
		if FFlagMomentsFlushDwellBeforeNavigation then
			local v25 = if FFlagMomentsNavigationEvent then NavigationDestinationType.Exit else nil
			v19(v25)
		end

		onBack()
	end, { onBack, v19 })
	local v24 = React.useCallback(function()
		fireAnalyticsEvent(eventNames.FeedHomeButtonPressed)
		local v26 = if FFlagMomentsNavigationEvent then NavigationDestinationType.Trending else nil
		v21(v26)
	end, { v21 })
	local openOwnMoments = props.openOwnMoments
	local v25 = React.useCallback(function()
		fireAnalyticsEvent(eventNames.MyCreationButtonPressed)

		if openOwnMoments ~= nil then
			if FFlagMomentsFlushDwellBeforeNavigation then
				local v27 = if FFlagMomentsNavigationEvent then NavigationDestinationType.MyMoments else nil
				v19(v27)
			end

			openOwnMoments()
		end
	end, { openOwnMoments, v19 })
	local v26 = defineFastFlag and feedKind == immersiveFeedKind.Trending

	local function fn()
		return React.createElement(MomentsBackHeader, {
			onBack = v23,
			onCreatePressed = if v8 then v7 else nil,
			onCreateAvatarMomentPressed = if fFlagMomentsCreateAvatarPosts then v20 else nil,
			onNavigateToTrending = if v26 then v24 else nil,
			onNavigateToMyMoments = if v26 then v25 else nil
		})
	end

	local v29 = React.useMemo(fn, {
		v23,
		v8,
		v7,
		if fFlagMomentsCreateAvatarPosts then v20 else nil,
		v26,
		v24,
		v25
	})
	local v30

	if FFlagMomentsNavigationEvent then
		if v9 then
			v30 = NavigationDestinationType.Create
		elseif v16 then
			v30 = NavigationDestinationType.Report
		end
	end

	local element = React.createElement(MomentsFeedSurface, {
		source = v11,
		telemetry = v12,
		inactiveDestination = v30,
		active = v13 and not v16 and not (v9 or v17),
		playbackActive = v13 and not v14 and not (v15 or v16) and not (v9 or v17),
		initialIndex = initialIndex,
		header = v29,
		controllerRef = ref
	})

	local v31 = React.createElement(PushedFeedSafeAreaProvider, nil, element)

	if v8 then
		local createElement = React.createElement

		local v35 = if v9 then React.createElement(
			view,
			{ tag = "size-full", ZIndex = Constants.DisplayOrder.Modals },
			{
				Screen = React.createElement(creationFlowScreen, { host = v6 })
			}
		) else nil

		local v36 = if v10 then React.createElement(
			view,
			{ tag = "size-full", ZIndex = Constants.DisplayOrder.Modals },
			{
				Screen = React.createElement(FTUXEducationScreen, { onClose = v5.onExitFtux })
			}
		) else nil
		v31 = createElement(view, {
			backgroundStyle = fFlagMomentsRenderAvatarPostsInFeed and {
				Transparency = 1
			} or nil,
			tag = {
				["size-full"] = fFlagMomentsRenderAvatarPostsInFeed,
				["size-full bg-surface-0"] = not fFlagMomentsRenderAvatarPostsInFeed
			}
		}, { Feed = v31, CreationFlowOverlay = v35, FtuxOverlay = v36 })
	end

	local createElement = React.createElement
	local v33 = {
		sessionStore = current,
		openProfile = props.openProfile,
		openOwnMoments = props.openOwnMoments,
		openMomentsFeedReport = props.openMomentsFeedReport,
		openAvatarLookTryOn = 0,
		openMomentCommentReport = 0,
		openBlockUser = 0
	}
	local v34 = if fFlagMomentsAvatarLookTryOn then props.openAvatarLookTryOn else nil
	v33.openAvatarLookTryOn = v34
	v33.openMomentCommentReport = props.openMomentCommentReport
	v33.openBlockUser = props.openBlockUser
	return createElement(MomentsHostShell, v33, v31)
end

return React.memo(MomentsImmersivePresentation)
