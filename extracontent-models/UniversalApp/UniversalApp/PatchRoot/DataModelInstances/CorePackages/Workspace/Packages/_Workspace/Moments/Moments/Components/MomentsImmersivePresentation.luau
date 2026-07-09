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
local createMomentsStore = require(Moments.Stores.GetMomentsStore.createMomentsStore)
local createMomentsFeedSource = require(Moments.Stores.GetMomentsStore.createMomentsFeedSource)
local createUserMomentsFeedSource = require(Moments.Stores.GetMomentsStore.createUserMomentsFeedSource)
local GetMomentsPreferencesStore = require(Moments.Stores.GetMomentsPreferencesStore)
local GetFFlagArgusStudioMockFeed = require(Moments.Flags.GetFFlagArgusStudioMockFeed)
local createSignalTracker = require(Moments.SignalTracker).createSignalTracker
local useNavigationFocus = Navigation.useNavigationFocus
local useSignalState = SignalsReact.useSignalState
local FFlagEnableArgus = SharedFlags.FFlagEnableArgus
local Analytics = MomentsCommon.Analytics
local EventNames = Analytics.EventNames
local fireAnalyticsEvent = Analytics.fireAnalyticsEvent
local feedPlaybackSuspension = MomentsCommon.Media.feedPlaybackSuspension
local createRecommendationTelemetry = Feed.createRecommendationTelemetry
local createMockFeedSource = Feed.createMockFeedSource

local function MomentsImmersivePresentation(t1: {[any]: any}) -- line: 67
	-- upvalues: React (copy), createMomentsStore (copy), FFlagEnableArgus (copy), createSignalTracker (copy), createUserMomentsFeedSource (copy), isStudio (copy), GetFFlagArgusStudioMockFeed (copy), createMockFeedSource (copy), createMomentsFeedSource (copy), createRecommendationTelemetry (copy), fireAnalyticsEvent (copy), EventNames (copy), useNavigationFocus (copy), useSignalState (copy), feedPlaybackSuspension (copy), GetMomentsPreferencesStore (copy), MomentsBackHeader (copy), MomentsHostShell (copy), MomentsFeedSurface (copy)
	local v30 = React.useRef(nil)

	if v30.current == nil then
		v30.current = createMomentsStore()
	end

	local current = v30.current
	local v32 = React.useRef(nil)

	if v32.current == nil and FFlagEnableArgus then
		v32.current = createSignalTracker()
	end

	local current2 = v32.current
	local feedKind = t1.feedKind
	local targetUserId = t1.targetUserId
	local initialIndex = t1.initialIndex
	local v37 = React.useMemo(function() -- line: 86
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
	local v38 = React.useMemo(function() -- line: 100
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
	local sessionSource = t1.sessionSource

	React.useEffect(function() -- line: 116
		-- upvalues: current (copy), sessionSource (copy), fireAnalyticsEvent (copy), EventNames (copy)
		current.setSessionSource(sessionSource)
		fireAnalyticsEvent(EventNames.TapMomentsTab, {
			moments_session_id = current.getMomentsSessionId(false),
			source = sessionSource
		})

		return function() -- line: 123
			-- upvalues: current (copy), fireAnalyticsEvent (copy), EventNames (copy), sessionSource (copy)
			local v46 = os.clock() - current.getSessionStartTime(false)

			fireAnalyticsEvent(EventNames.MomentsSessionEnded, {
				moments_session_id = current.getMomentsSessionId(false),
				source = sessionSource,
				duration_seconds = tostring((math.floor(v46)))
			})
		end
	end, {
		sessionSource,
		current
	})

	local v40 = useNavigationFocus()
	local v41 = useSignalState(feedPlaybackSuspension.getSuspended)
	local v42 = useSignalState(GetMomentsPreferencesStore(false).getIsTeleporting)
	local v43 = v40 and (not v41 and not v42)
	local onBack = t1.onBack
	local v45 = React.useMemo(function() -- line: 147
		-- upvalues: React (copy), MomentsBackHeader (copy), onBack (copy)
		return React.createElement(MomentsBackHeader, {
			onBack = onBack
		})
	end, { onBack })

	return React.createElement(MomentsHostShell, {
		sessionStore = current,
		openProfile = t1.openProfile,
		openOwnMoments = t1.openOwnMoments
	}, React.createElement(MomentsFeedSurface, {
		source = v37,
		telemetry = v38,
		active = v40,
		playbackActive = v43,
		initialIndex = initialIndex,
		header = v45
	}))
end

return React.memo(MomentsImmersivePresentation)
