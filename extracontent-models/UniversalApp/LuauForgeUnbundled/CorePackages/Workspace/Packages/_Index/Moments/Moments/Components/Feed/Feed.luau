local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Localization")
local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/MomentsCommon")
require("@game/CorePackages/Workspace/Packages/_Index/Moments/MomentsTypes")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SharedFlags")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SignalsReact")

local useLocalization = Localization.Hooks.useLocalization

local analytics = MomentsCommon.Analytics
local eventNames = analytics.EventNames
local fireAnalyticsEvent = analytics.fireAnalyticsEvent
local momentsSurfaceLoadManager = MomentsCommon.Performance.MomentsSurfaceLoadManager
local fFlagMomentsRemoveDeletedFromProfile = SharedFlags.FFlagMomentsRemoveDeletedFromProfile
local fFlagMomentsOptimisticProfilePending = SharedFlags.FFlagMomentsOptimisticProfilePending
local fFlagMomentsRenderAvatarPostsInFeed = SharedFlags.FFlagMomentsRenderAvatarPostsInFeed
local fFlagMomentsFeedMediaLoadAttemptedEvent = MomentsCommon.Flags.FFlagMomentsFeedMediaLoadAttemptedEvent
local fFlagMomentsComments = SharedFlags.FFlagMomentsComments
local fFlagMomentsCommentDeepLinks = SharedFlags.FFlagMomentsCommentDeepLinks

local v5 = if fFlagMomentsComments then require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/Sheet/getCommentsSheetStore") else nil

local FFlagMomentsCreatorAnalytics = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsCreatorAnalytics")

local v6 = if FFlagMomentsCreatorAnalytics then require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/PostInsights/getPostInsightsPageStore") else nil

local VerticalPager = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/VerticalPager")

require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/FeedTypes")
local FeedContext = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/FeedContext")
local FeedStateView = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/FeedStateView")
local createFeedStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/createFeedStore")
local feedItemRegistry = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/feedItemRegistry")
local feedTelemetry = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/feedTelemetry")
local getFeedScrollLimit = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/getFeedScrollLimit")
local useFeedTelemetry = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/useFeedTelemetry")
local FeedNavigationBar = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/FeedNavigationBar")
local ImmersiveChromeController = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/ImmersiveChromeController")
local DeletionConfirmationDialog = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/DeletionConfirmationDialog")
local GetImmersiveChromeStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetImmersiveChromeStore")
local FFlagMomentsCommentsCloseOnFeedJump = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsCommentsCloseOnFeedJump")
local getMomentsCapabilities = MomentsCommon.Stores.GetMomentsCapabilities
local useMomentsSession = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetMomentsStore/MomentsSessionContext").useMomentsSession
local FFlagMomentsDeleteSnackbar = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsDeleteSnackbar")
local FFlagMomentsFixDeleteToastCopy = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsFixDeleteToastCopy")
local getFFlagMomentsNonInfiniteScroll = MomentsCommon.Flags.GetFFlagMomentsNonInfiniteScroll
local GetToastStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetToastStore")
local GetDeletedMomentsStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetDeletedMomentsStore")
local deleteMoment = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Moderation/deleteMoment")
local logMomentViewBegan = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Analytics/logMomentViewBegan")
local FFlagMomentsImpressionPrimaryEntity = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsImpressionPrimaryEntity")
local useMomentsHost = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/MomentsHostContext").useMomentsHost
local FFlagMomentsNavigationEvent = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsNavigationEvent")
local logFeedEndStateReached = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Analytics/logFeedEndStateReached")
local makeFeedActionFields = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Analytics/makeFeedActionFields")

local MomentMediaCoordinatorProvider = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Media/MomentMediaCoordinatorProvider")
local module32 = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/SurfaceReadyTracker")
local SwipeLatencyTracker = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/SwipeLatencyTracker")

local verticalPager = VerticalPager.VerticalPager

local feedContext = FeedContext.FeedContext

local noopTelemetry = feedTelemetry.createNoopTelemetry()

local v7 = {
	deletedTitle = "Feature.Moments.Label.MomentDeletedTitle",
	deletedBody = "Feature.Moments.Label.MomentDeletedBody",
	deletedToast = "Feature.Moments.Label.PostDeleted"
}

local function renderFeedItem(p2, p3)
	local v8 = feedItemRegistry[p2.kind]

	if v8 == nil then
		return nil
	end

	return (v8.render(p2, p3))
end

local function feedItemKey(p2, p3)
	local v8 = feedItemRegistry[p2.kind]
	local v9 = if v8 ~= nil then v8.getKey(p2) else nil

	if v9 == nil or v9 == "" then
		return (tostring(p3))
	end

	return v9
end

local function feedItemDedupeKey(p2)
	local v8 = feedItemRegistry[p2.kind]

	if v8 == nil then
		return nil
	end

	return (v8.getKey(p2))
end

local function feedItemAttribution(p2)
	local v8 = feedItemRegistry[p2.kind]

	if v8 == nil then
		return nil
	end

	return (v8.getAttribution(p2))
end

local function stringOrNil(p2)
	if p2 == nil then
		return nil
	end

	return (tostring(p2))
end

local function makeMediaLoadEventFields(data, source)
	local recommendationMetadata = data.recommendationMetadata
	local mediaLoadEventFields = {
		momentId = data.momentId,
		assetId = tostring(data.assetId),
		captureType = data.metadata.captureType.Name,
		creatorId = tostring(data.creatorId),
		itemId = 0,
		tracingId = 0,
		recommendationSource = 0,
		feedSourceId = 0,
		placeId = 0,
		universeId = 0
	}
	local v8 = if recommendationMetadata ~= nil then recommendationMetadata.feedItemId else nil
	mediaLoadEventFields.itemId = v8
	local v9 = if recommendationMetadata ~= nil then recommendationMetadata.tracingId else nil
	mediaLoadEventFields.tracingId = v9
	mediaLoadEventFields.recommendationSource = source.recommendationSource or ""
	mediaLoadEventFields.feedSourceId = source.id or ""
	local placeId = data.metadata.placeId
	local v10 = if placeId ~= nil then tostring(placeId) else nil

	mediaLoadEventFields.placeId = v10
	local universeId = data.metadata.universeId
	local v11 = if universeId ~= nil then tostring(universeId) else nil

	mediaLoadEventFields.universeId = v11
	return mediaLoadEventFields
end

local logger = nil
local function getLogger()
	if logger == nil then
		logger = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Loggers").Logger:new("Moments.Feed")
	end

	return logger
end

local function Feed(props)
	local source = props.source
	local v8 = props.active == nil or props.active

	local v9 = if props.playbackActive == nil then v8 else props.playbackActive
	local v10 = props.showNavigationBar == nil or props.showNavigationBar
	local telemetry = props.telemetry or noopTelemetry
	local trackSurfaceLoad = props.trackSurfaceLoad == true
	local v11, v12

	if fFlagMomentsComments and v5 ~= nil then
		v11 = SignalsReact.useSignalState(v5(false).getIsOpen)

		v12 = SignalsReact.useSignalState(v5(false).getIsExpanded)
	else
		v11 = false
		v12 = false
	end

	local v13 = v8 and not v11
	local v14

	if FFlagMomentsCreatorAnalytics and v6 ~= nil then
		v14 = SignalsReact.useSignalState(v6(false).getIsOpen)

		if v14 then
			v13 = false
		end
	else
		v14 = false
	end

	local v15 = not (FFlagMomentsCreatorAnalytics and v14) and (v9 and not v12)
	local v16 = GetImmersiveChromeStore(false)

	local v17 = useLocalization(v7)

	local v18 = useMomentsSession()
	local v19 = GetToastStore(false)
	local v20 = SignalsReact.useSignalState(v18.getPendingDeletion)

	local v21 = React.useMemo(function()
		return createFeedStore(
			source,
			feedItemDedupeKey,
			trackSurfaceLoad,
			(getFeedScrollLimit(true, getFFlagMomentsNonInfiniteScroll(), function()
				return getMomentsCapabilities(false)
			end))
		)
	end, { source, trackSurfaceLoad })

	React.useEffect(function()
		v21.loadInitial()
		return function()
			v21.dispose()
		end
	end, { v21 })

	if FFlagMomentsCommentsCloseOnFeedJump and v5 ~= nil then
		React.useEffect(function()
			if not v8 then
				return
			end

			local v22 = v5(false)

			local function getCurrentPosition(p2)
				local currentItem = v21.pager.getCurrentItem(p2)

				if currentItem == nil or currentItem.kind == "skeleton" then
					return nil
				end

				if
					currentItem.kind ~= "moment"
					and (not fFlagMomentsRenderAvatarPostsInFeed or currentItem.kind ~= "avatarMoment")
				then
					return `kind:{currentItem.kind}`
				end

				local moment = currentItem.moment
				return moment.recommendationMetadata.feedItemId or `moment:{moment.momentId}`
			end

			local v23 = getCurrentPosition(false)
			return Signals.createEffect(function(p2)
				local currentPosition = getCurrentPosition(p2)

				if currentPosition == nil or currentPosition == v23 then
					return
				end

				local v24 = v23
				v23 = currentPosition

				if v24 ~= nil and v22.getIsOpen(false) and v22.getFeedItemId(false) == v24 then
					v22.close()
				end
			end)
		end, { v8, v21 })
	end

	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)

	local ref3 = React.useRef(nil)
	local v22 = React.useMemo(function()
		local v23 = {}
		function v23.onTargetCommitted(p2, p3, p4)
			local current = ref2.current

			if current ~= nil then
				current(p2, p3, p4)
			end
		end

		if FFlagMomentsNavigationEvent then
			function v23.onUserStep(p2, p3)
				local current = ref3.current

				if current ~= nil then
					current(p2, p3)
				end
			end
		end

		return v23
	end, {})
	local ref4 = React.useRef(0)
	local ref5 = React.useRef(false)
	local ref6 = React.useRef(0)

	local ref7 = React.useRef(nil)
	local v23 = React.useCallback(function(p2)
		if ref5.current or DateTime.now().UnixTimestampMillis < ref4.current then
			return
		end

		local current = ref7.current

		if FFlagMomentsNavigationEvent and p2 ~= nil and current ~= nil then
			current(p2)
		end

		ref5.current = true
		ref6.current += 1
		local current2 = ref6.current
		v21.refresh()

		task.spawn(function()
			while ref5.current and current2 == ref6.current do
				local status = v21.getStatus(false)

				if status == "Loaded" or status == "Empty" then
					ref5.current = false
					ref4.current = DateTime.now().UnixTimestampMillis + 1000
					break
				elseif status == "Failed" then
					ref5.current = false
					break
				else
					task.wait()
				end
			end
		end)
	end, { v21 })

	local v24 = React.useCallback(function(p2)
		v21.prependItem({ kind = "moment", moment = p2 })
		local current = ref.current

		if current ~= nil then
			current.scrollToIndex(1)
		end
	end, { v21 })

	local ref8 = React.useRef(nil)
	local v25 = useMomentsHost().openAvatarLookTryOn ~= nil
	local v26 = React.useCallback(function(p2)
		if
			p2.kind ~= "moment"
			and (not fFlagMomentsRenderAvatarPostsInFeed or p2.kind ~= "avatarMoment")
		then
			return
		end

		local moment = p2.moment
		local current = ref8.current

		local sessionSource = v18.getSessionSource(false)
		local v28 = if FFlagMomentsNavigationEvent and current ~= nil then current() else nil
		logMomentViewBegan(moment, sessionSource, v28, if FFlagMomentsImpressionPrimaryEntity then v25 else nil)
	end, { v18, v25 })

	local v27 = props.telemetry ~= nil
	local v28 = React.useCallback(function(p2, data)
		local makeMomentsNavigationFields = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Analytics/makeMomentsNavigationFields")
		fireAnalyticsEvent(eventNames.MomentsNavigationEvent, makeMomentsNavigationFields({
			feedItemId = p2.itemId,
			viewId = data.viewId,
			durationSeconds = data.durationSeconds,
			destinationType = data.destination,
			itemPosition = data.itemPosition,
			tracingId = p2.tracingId,
			includeRecommendationDetail = v27,
			clientEventTimestampMs = DateTime.now().UnixTimestampMillis
		}))
	end, { v27 })

	local v29 = React.useCallback(function(p2)
		logFeedEndStateReached({
			source = v18.getSessionSource(false),
			recommendationSource = source.recommendationSource or "",
			feedSourceId = source.id or "",
			itemPosition = p2
		})
	end, { v18, source })

	local pager = v21.pager
	local v31 = {
		telemetry = telemetry,
		active = v8,
		getAttribution = feedItemAttribution,
		recommendationSource = source.recommendationSource,
		onItemBecameActive = v26,
		onEndStateReached = 0,
		onViewEnded = 0,
		inactiveDestination = 0
	}

	if not getFFlagMomentsNonInfiniteScroll() and source.endsWithCaughtUp ~= true then
		v29 = nil
	end

	v31.onEndStateReached = v29

	if not FFlagMomentsNavigationEvent then
		v28 = nil
	end

	v31.onViewEnded = v28
	local v32 = if FFlagMomentsNavigationEvent then props.inactiveDestination else nil
	v31.inactiveDestination = v32
	local v33 = useFeedTelemetry(pager, v31)

	ref8.current = v33.getViewId
	ref7.current = v33.flushView
	ref3.current = v33.noteUserStep

	React.useImperativeHandle(props.controllerRef, function()
		return { prependMoment = v24, refresh = v23, flushView = v33.flushView }
	end, { v24, v23, v33.flushView })

	local ref9 = React.useRef(v9)
	React.useEffect(function()
		local current = ref9.current
		ref9.current = v9

		if v9 and not current then
			local currentItem = v21.pager.getCurrentItem(false)

			if currentItem ~= nil then
				v26(currentItem)
			end
		end
	end, { v9, v21, v26 })

	local v34 = React.useCallback(function()
		local current = ref.current

		if current ~= nil then
			current.next()
		end
	end, {})
	local v35 = React.useCallback(function()
		local current = ref.current

		if current ~= nil then
			current.previous()
		end
	end, {})

	local v36 = SignalsReact.useSignalState(v21.getStatus)
	local v37, v38

	if fFlagMomentsOptimisticProfilePending then
		v37 = SignalsReact.useSignalState(v21.getInitialIndex)
		v38 = SignalsReact.useSignalState(v21.getError)
	end

	local v39 = SignalsReact.useSignalState(v21.getLoadMoreFailed)
	local ref10 = React.useRef({})

	React.useEffect(function()
		return function()
			ref6.current += 1
			ref5.current = false
			ref4.current = 0
		end
	end, { v21 })

	local ref11 = React.useRef(false)
	local ref12 = React.useRef(false)

	React.useEffect(function()
		if not ref11.current then
			ref11.current = true

			if trackSurfaceLoad then
				momentsSurfaceLoadManager.renderStarted()
				momentsSurfaceLoadManager.surfaceMounted()
			end

			local momentsFirstUIRenderedTimestamp = eventNames.MomentsFirstUIRenderedTimestamp
			local v42 = if trackSurfaceLoad and momentsSurfaceLoadManager.isSessionActive() then momentsSurfaceLoadManager.elapsedMs() else DateTime.now().UnixTimestampMillis
			fireAnalyticsEvent(momentsFirstUIRenderedTimestamp, { value = v42 })
		end
	end, {})

	React.useEffect(function()
		if trackSurfaceLoad then
			return
		end

		if not ref12.current and (v36 == "Loaded" or v36 == "LoadingMore") then
			ref12.current = true
			fireAnalyticsEvent(eventNames.MomentsFirstContentLoadedTimestamp, {
				value = DateTime.now().UnixTimestampMillis
			})
		end
	end, { v36 })

	local ref13 = React.useRef(nil)

	React.useEffect(function()
		if v36 ~= ref13.current then
			if v36 == "Failed" then
				fireAnalyticsEvent(eventNames.FeedLoadFailed, {
					recommendationSource = source.recommendationSource or "",
					feedSourceId = source.id or "",
					failureReason = v21.getError(false) or ""
				})
			elseif v36 == "Empty" then
				fireAnalyticsEvent(eventNames.FeedNoMomentsFetched, {
					recommendationSource = source.recommendationSource or "",
					feedSourceId = source.id or ""
				})
			end
		end

		ref13.current = v36
	end, { v36 })

	local ref14 = React.useRef(false)

	React.useEffect(function()
		if v39 and not ref14.current then
			local v40 = v21.pager.getItems(false)[v21.pager.getCurrentIndex(false)]
			local v41

			if v40 ~= nil then
				local v42 = feedItemRegistry[v40.kind]

				if v42 ~= nil then
					v41 = v42.getAttribution(v40)
				end
			end

			local feedLoadMoreFailed = eventNames.FeedLoadMoreFailed
			local v43 = {
				recommendationSource = source.recommendationSource or "",
				feedSourceId = source.id or "",
				itemId = 0,
				tracingId = 0
			}
			local v44 = if v41 ~= nil then v41.itemId else nil
			v43.itemId = v44
			local v45 = if v41 ~= nil then v41.tracingId else nil
			v43.tracingId = v45
			fireAnalyticsEvent(feedLoadMoreFailed, v43)
		end

		ref14.current = v39
	end, { v39 })

	local v40 = React.useCallback(function()
		local currentIndex = v21.pager.getCurrentIndex(false)
		local current = ref.current

		if current ~= nil then
			current.removeItem(currentIndex)
		end
	end, { v21 })

	local v41 = React.useCallback(function()
		if v20 then
			local momentId = v20.momentId
			local feedItemId = v20.feedItemId
			local feedSessionId = v20.feedSessionId

			if feedItemId == nil or feedItemId == "" then
				v18.clearPendingDeletion()
				return
			end

			task.spawn(function()
				local v42, v43 = deleteMoment(feedItemId):await()

				if not v42 then
					if logger == nil then
						logger = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Loggers").Logger:new("Moments.Feed")
					end

					logger:warning("Failed to delete moment {}: {}", momentId, (tostring(v43)))
				end
			end)
			v40()

			if fFlagMomentsRemoveDeletedFromProfile or fFlagMomentsOptimisticProfilePending then
				GetDeletedMomentsStore(false).markDeleted(momentId)
			end

			local v42 = makeFeedActionFields(momentId, feedItemId, feedSessionId, "delete")

			if v42 then
				fireAnalyticsEvent(eventNames.MomentItemDeleted, v42)
			end

			if FFlagMomentsDeleteSnackbar then
				v19.triggerToast({
					title = v17.deletedToast,
					text = "",
					variant = "snackbar"
				})
			elseif FFlagMomentsFixDeleteToastCopy then
				v19.triggerToast({ title = v17.deletedToast, text = "" })
			else
				v19.triggerToast({ title = v17.deletedTitle, text = v17.deletedBody })
			end
		end

		v18.clearPendingDeletion()
	end, { v20, v18, v19, v17, v40 })

	local v42 = React.useCallback(function()
		v18.clearPendingDeletion()
	end, { v18 })

	local v43 = React.useCallback(function(data, failureReason)
		if logger == nil then
			logger = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Loggers").Logger:new("Moments.Feed")
		end

		logger:debug(
			"Filtering moment after media load failure | momentId: {}, assetId: {}, captureType: {}, failureReason: {}",
			data.momentId,
			tostring(data.assetId),
			data.metadata.captureType.Name,
			failureReason or "nil"
		)

		local mediaLoadEventFields = makeMediaLoadEventFields(data, source)

		if failureReason ~= nil then
			mediaLoadEventFields.failureReason = failureReason
		end

		fireAnalyticsEvent(eventNames.FeedMediaLoadFailed, mediaLoadEventFields)
	end, { source })

	local v44 = React.useCallback(function(p2, p3)
		if ref10.current[p2] then
			return
		end

		local items = v21.pager.getItems(false)

		for k, item in items do
			if
				(item.kind == "moment" or fFlagMomentsRenderAvatarPostsInFeed and item.kind == "avatarMoment")
				and item.moment.momentId == p2
			then
				ref10.current[p2] = true
				v43(item.moment, p3)
				local current = ref.current

				if current == nil then
					v21.pager.removeItem(k)
				else
					current.removeItem(k)
				end

				break
			end
		end
	end, { v21, v43 })

	local v45 = React.useCallback(function(p2)
		analytics.reportMomentsFeedMediaLoad("attempted", v21.observabilityFeedType)

		if fFlagMomentsFeedMediaLoadAttemptedEvent then
			for k, v46 in v21.pager.getItems(false) do
				if v46.kind == "moment" and v46.moment.momentId == p2 then
					fireAnalyticsEvent(
						eventNames.FeedMediaLoadAttempted,
						makeMediaLoadEventFields(v46.moment, source)
					)
					return
				end
			end
		end
	end, { v21, source })

	local v46 = React.useCallback(function(p2, p3)
		analytics.reportMomentsFeedMediaLoad("failed", v21.observabilityFeedType, p3)
		v44(p2, p3)
	end, { v21, v44 })

	local v47 = React.useMemo(function()
		local v48 = {
			getStatus = v21.getStatus,
			isActiveFeed = v8,
			isPlaybackActive = v9,
			getCurrentIndex = 0,
			getCurrentItem = 0,
			recommendationSource = 0,
			logAction = 0,
			flushView = 0,
			getChromeVisible = 0,
			revealChrome = 0,
			removeCurrentItem = 0,
			scrollToNext = 0,
			loadMoreBeyondLimit = 0,
			getCanLoadMoreBeyondLimit = 0,
			caughtUpState = 0
		}

		local v49 = if fFlagMomentsRenderAvatarPostsInFeed then v21.pager.getCurrentIndex else nil
		v48.getCurrentIndex = v49
		local v50 = if fFlagMomentsCommentDeepLinks then v21.pager.getCurrentItem else nil
		v48.getCurrentItem = v50
		v48.recommendationSource = source.recommendationSource
		function v48.logAction(p2, p3, p4)
			return telemetry.logAction(p2, p3, p4)
		end

		v48.flushView = v33.flushView

		v48.getChromeVisible = v16.getChromeVisible
		v48.revealChrome = v16.revealChrome
		v48.removeCurrentItem = v40
		v48.scrollToNext = v34
		local v51 = if getFFlagMomentsNonInfiniteScroll() then v21.loadBeyondLimit else nil
		v48.loadMoreBeyondLimit = v51
		v48.getCanLoadMoreBeyondLimit = v21.getCanLoadMoreBeyondLimit
		v48.caughtUpState = props.caughtUpState
		return v48
	end, {
		v21,
		v8,
		v9,
		source,
		telemetry,
		v33.flushView,
		v16,
		v40,
		v34,
		props.caughtUpState
	})

	local v48 = v36 == "Loaded" or v36 == "LoadingMore"

	local v50 = if v13 then not (v36 == "Failed") and v36 ~= "Empty" else v13

	local createElement = React.createElement
	local provider = feedContext.Provider

	local createElement2 = React.createElement
	local v54 = {
		AnchorPoint = props.AnchorPoint,
		BackgroundTransparency = 1,
		LayoutOrder = props.LayoutOrder,
		Position = props.Position,
		Size = props.Size or UDim2.fromScale(1, 1),
		ZIndex = props.ZIndex
	}

	local createElement3 = React.createElement
	local v56 = {
		store = v21.pager,
		renderItem = renderFeedItem,
		keyExtractor = feedItemKey,
		analytics = v22,
		onEndReached = v21.loadMore,
		active = v50,
		controllerRef = ref,
		initialIndex = 0,
		tuning = 0,
		Size = 0,
		ZIndex = 1
	}

	local v57 = if fFlagMomentsOptimisticProfilePending then v37 or props.initialIndex else props.initialIndex
	v56.initialIndex = v57

	v56.tuning = props.pager
	v56.Size = UDim2.fromScale(1, 1)
	local children = {
		Pager = createElement3(verticalPager, v56),
		StateOverlay = React.createElement(FeedStateView, {
			status = v36,
			loadMoreFailed = v39 or fFlagMomentsOptimisticProfilePending and v38 ~= nil,
			onRetry = v21.retry,
			emptyContent = props.emptyContent,
			emptyState = props.emptyState,
			zIndex = 2
		}),
		NavBar = 0,
		ImmersiveController = 0,
		SwipeLatency = 0,
		DeletionDialog = 0
	}

	local v58 = if v10 and v48 then React.createElement(FeedNavigationBar, {
		pager = v21.pager,
		active = v13,
		onScrollToNext = v34,
		onScrollToPrevious = v35,
		zIndex = 3
	}) else nil
	children.NavBar = v58

	children.ImmersiveController = React.createElement(ImmersiveChromeController, {
		pager = v21.pager,
		active = v8 and v9,
		controllerRef = ref,
		coveringOverlay = v11
	})

	children.SwipeLatency = React.createElement(SwipeLatencyTracker, {
		pager = v21.pager,
		controllerRef = ref,
		onTargetCommittedRef = ref2
	})

	local v59 = if v20 ~= nil then React.createElement(DeletionConfirmationDialog, {
		onCancel = v42,
		onConfirm = v41
	}) else nil
	children.DeletionDialog = v59
	local element = createElement(provider, { value = v47 }, {
		Root = createElement2("Frame", v54, children)
	})

	return React.createElement(MomentMediaCoordinatorProvider, {
		pager = v21.pager,
		playbackActive = v15,
		createCoordinator = props.createCoordinator,
		onMediaItemLoadAttempted = v45,
		onMediaItemFailed = v46
	}, trackSurfaceLoad and {
		Feed = element,
		SurfaceReadyTracker = React.createElement(module32, { pager = v21.pager })
	} or element)
end

return Feed
