local Moments = script:FindFirstAncestor("Moments")
local MomentsParent = Moments.Parent
local React = require(MomentsParent.React)
local Navigation = require(MomentsParent.Navigation)
local SharedFlags = require(MomentsParent.SharedFlags)
local SignalsReact = require(MomentsParent.SignalsReact)
local MomentsCommon = require(MomentsParent.MomentsCommon)
local isStudio = require(MomentsParent.MomentsCommon.isStudio)
local MomentsHostShell = require(Moments.Components.MomentsHostShell)
local MomentsFeedSurface = require(Moments.Components.MomentsFeedSurface)
local MomentsBackHeader = require(Moments.Components.MomentsBackHeader)
local Feed = require(Moments.Components.Feed)
local MomentPushedFeedSafeAreaContext = require(Moments.Components.Feed.Items.Moment.MomentPushedFeedSafeAreaContext)
local createMomentsStore = require(Moments.Stores.GetMomentsStore.createMomentsStore)
local createMomentsFeedSource = require(Moments.Stores.GetMomentsStore.createMomentsFeedSource)
local createUserMomentsFeedSource = require(Moments.Stores.GetMomentsStore.createUserMomentsFeedSource)
local GetMomentsPreferencesStore = require(Moments.Stores.GetMomentsPreferencesStore)
local GetFFlagArgusStudioMockFeed = require(Moments.Flags.GetFFlagArgusStudioMockFeed)
local GetFFlagMomentsPushedFeedSafeArea = require(Moments.Flags.GetFFlagMomentsPushedFeedSafeArea)
local createSignalTracker = require(Moments.SignalTracker).createSignalTracker
local useNavigationFocus = Navigation.useNavigationFocus
local useSignalState = SignalsReact.useSignalState
local FFlagEnableArgus = SharedFlags.FFlagEnableArgus
local Analytics = MomentsCommon.Analytics
local EventNames = Analytics.EventNames
local fireAnalyticsEvent = Analytics.fireAnalyticsEvent
local feedPlaybackSuspension = MomentsCommon.Media.feedPlaybackSuspension
local useDeviceInsets = MomentsCommon.Hooks.useDeviceInsets
local createRecommendationTelemetry = Feed.createRecommendationTelemetry
local createMockFeedSource = Feed.createMockFeedSource

local function PushedFeedSafeAreaProvider(t1: {[any]: any}) -- line: 75
	-- upvalues: useDeviceInsets (copy), React (copy), MomentPushedFeedSafeAreaContext (copy)
	local v34 = useDeviceInsets()

	return React.createElement(MomentPushedFeedSafeAreaContext.Context.Provider, {
		value = v34
	}, {
		Content = t1.children
	})
end
local function MomentsImmersivePresentation(t2: {[any]: any}) -- line: 85
	-- upvalues: React (copy), createMomentsStore (copy), FFlagEnableArgus (copy), createSignalTracker (copy), createUserMomentsFeedSource (copy), isStudio (copy), GetFFlagArgusStudioMockFeed (copy), createMockFeedSource (copy), createMomentsFeedSource (copy), createRecommendationTelemetry (copy), fireAnalyticsEvent (copy), EventNames (copy), useNavigationFocus (copy), useSignalState (copy), feedPlaybackSuspension (copy), GetMomentsPreferencesStore (copy), MomentsBackHeader (copy), MomentsFeedSurface (copy), GetFFlagMomentsPushedFeedSafeArea (copy), PushedFeedSafeAreaProvider (copy), MomentsHostShell (copy)
	local v36 = React.useRef(nil)

	if v36.current == nil then
		v36.current = createMomentsStore()
	end

	local current = v36.current
	local v38 = React.useRef(nil)

	if v38.current == nil and FFlagEnableArgus then
		v38.current = createSignalTracker()
	end

	local current2 = v38.current
	local feedKind = t2.feedKind
	local targetUserId = t2.targetUserId
	local initialIndex = t2.initialIndex
	local v43 = React.useMemo(function() -- line: 104
		-- upvalues: feedKind (copy), createUserMomentsFeedSource (copy), targetUserId (copy), initialIndex (copy), isStudio (copy), GetFFlagArgusStudioMockFeed (copy), createMockFeedSource (copy), createMomentsFeedSource (copy), current (copy), current2 (copy)
		if feedKind == "user" then
			return createUserMomentsFeedSource(targetUserId or 0, {
				initialIndex = initialIndex
			})
		end

		if isStudio() and GetFFlagArgusStudioMockFeed() then
			return createMockFeedSource()
		end

		return createMomentsFeedSource(current.getMomentsSessionId, {
			signalTracker = current2
		})
	end, {
		feedKind,
		targetUserId,
		initialIndex,
		current,
		current2
	})
	local v44 = React.useMemo(function() -- line: 118
		-- upvalues: feedKind (copy), FFlagEnableArgus (copy), createRecommendationTelemetry (copy), current (copy), current2 (copy)
		if feedKind ~= "trending" or not FFlagEnableArgus then
			return nil
		end

		return createRecommendationTelemetry({
			getMomentsSessionId = current.getMomentsSessionId,
			signalTracker = current2
		})
	end, {
		feedKind,
		current,
		current2
	})
	local sessionSource = t2.sessionSource

	React.useEffect(function() -- line: 134
		-- upvalues: current (copy), sessionSource (copy), fireAnalyticsEvent (copy), EventNames (copy)
		current.setSessionSource(sessionSource)
		fireAnalyticsEvent(EventNames.TapMomentsTab, {
			moments_session_id = current.getMomentsSessionId(false),
			source = sessionSource
		})

		return function() -- line: 141
			-- upvalues: current (copy), fireAnalyticsEvent (copy), EventNames (copy), sessionSource (copy)
			local v54 = os.clock() - current.getSessionStartTime(false)

			fireAnalyticsEvent(EventNames.MomentsSessionEnded, {
				moments_session_id = current.getMomentsSessionId(false),
				source = sessionSource,
				duration_seconds = tostring((math.floor(v54)))
			})
		end
	end, {
		sessionSource,
		current
	})

	local v46 = useNavigationFocus()
	local v47 = useSignalState(feedPlaybackSuspension.getSuspended)
	local v48 = useSignalState(GetMomentsPreferencesStore(false).getIsTeleporting)
	local v49 = v46 and (not v47 and not v48)
	local onBack = t2.onBack
	local v51 = React.useMemo(function() -- line: 165
		-- upvalues: React (copy), MomentsBackHeader (copy), onBack (copy)
		return React.createElement(MomentsBackHeader, {
			onBack = onBack
		})
	end, { onBack })
	local v52 = React.createElement(MomentsFeedSurface, {
		source = v43,
		telemetry = v44,
		active = v46,
		playbackActive = v49,
		initialIndex = initialIndex,
		header = v51
	})
	local v53 = if not GetFFlagMomentsPushedFeedSafeArea() then v52 else React.createElement(PushedFeedSafeAreaProvider, nil, v52)

	return React.createElement(MomentsHostShell, {
		sessionStore = current,
		openProfile = t2.openProfile,
		openOwnMoments = t2.openOwnMoments,
		openMomentsFeedReport = t2.openMomentsFeedReport
	}, v53)
end

return React.memo(MomentsImmersivePresentation)
