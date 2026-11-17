local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local Localization = require(parent.Localization)
local MomentsCommon = require(parent.MomentsCommon)
require(parent.MomentsTypes)
local React = require(parent.React)
local SharedFlags = require(parent.SharedFlags)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)

local useLocalization = Localization.Hooks.useLocalization

local Analytics = MomentsCommon.Analytics
local EventNames = Analytics.EventNames
local fireAnalyticsEvent = Analytics.fireAnalyticsEvent
local MomentsSurfaceLoadManager = MomentsCommon.Performance.MomentsSurfaceLoadManager
local FFlagMomentsPostInsightsIxpEnabled = require(Moments.Flags.FFlagMomentsPostInsightsIxpEnabled)
local FFlagMomentsRemoveDeletedFromProfile = SharedFlags.FFlagMomentsRemoveDeletedFromProfile
local FFlagMomentsOptimisticProfilePending = SharedFlags.FFlagMomentsOptimisticProfilePending
local FFlagMomentsRenderAvatarPostsInFeed = SharedFlags.FFlagMomentsRenderAvatarPostsInFeed
local FFlagMomentsFeedMediaLoadAttemptedEvent = MomentsCommon.Flags.FFlagMomentsFeedMediaLoadAttemptedEvent
local FFlagMomentsComments = SharedFlags.FFlagMomentsComments
local FFlagMomentsCommentDeepLinks = SharedFlags.FFlagMomentsCommentDeepLinks
local getCommentsSheetStore

if FFlagMomentsComments then
	getCommentsSheetStore = require(Moments.Components.Comments.Sheet.getCommentsSheetStore)
else
	getCommentsSheetStore = nil
end

local FFlagMomentsCreatorAnalytics = require(Moments.Flags.FFlagMomentsCreatorAnalytics)
local getPostInsightsPageStore

if FFlagMomentsCreatorAnalytics then
	getPostInsightsPageStore = require(Moments.Components.PostInsights.getPostInsightsPageStore)
else
	getPostInsightsPageStore = nil
end

local VerticalPager = require(Moments.Components.VerticalPager)

require(script.Parent.FeedTypes)
local FeedContext = require(script.Parent.FeedContext)
local FeedStateView = require(script.Parent.FeedStateView)
local createFeedStore = require(script.Parent.createFeedStore)
local feedItemRegistry = require(script.Parent.feedItemRegistry)
local feedTelemetry = require(script.Parent.feedTelemetry)
local getFeedScrollLimit = require(script.Parent.getFeedScrollLimit)
local useFeedTelemetry = require(script.Parent.useFeedTelemetry)
local FeedNavigationBar = require(script.Parent.FeedNavigationBar)
local ImmersiveChromeController = require(script.Parent.ImmersiveChromeController)
local DeletionConfirmationDialog = require(script.Parent.DeletionConfirmationDialog)
local GetImmersiveChromeStore = require(Moments.Stores.GetImmersiveChromeStore)
local FFlagMomentsCommentsCloseOnFeedJump = require(Moments.Flags.FFlagMomentsCommentsCloseOnFeedJump)
local GetMomentsCapabilities = MomentsCommon.Stores.GetMomentsCapabilities
local MomentsSessionContext = require(Moments.Stores.GetMomentsStore.MomentsSessionContext)
local useMomentsSession = MomentsSessionContext.useMomentsSession
local FFlagMomentsDeleteSnackbar = require(Moments.Flags.FFlagMomentsDeleteSnackbar)
local FFlagMomentsFixDeleteToastCopy = require(Moments.Flags.FFlagMomentsFixDeleteToastCopy)
local GetFFlagMomentsNonInfiniteScroll = MomentsCommon.Flags.GetFFlagMomentsNonInfiniteScroll
local GetToastStore = require(Moments.Stores.GetToastStore)
local GetDeletedMomentsStore = require(Moments.Stores.GetDeletedMomentsStore)
local getExperienceDetailsSheetStore = require(Moments.ExperienceDetailsSheet.Sheet.getExperienceDetailsSheetStore)
local FFlagMomentsParentTimeLimit = MomentsCommon.Flags.FFlagMomentsParentTimeLimit
local deleteMoment = require(Moments.Moderation.deleteMoment)
local logMomentViewBegan = require(Moments.Analytics.logMomentViewBegan)
local FFlagMomentsImpressionPrimaryEntity = require(Moments.Flags.FFlagMomentsImpressionPrimaryEntity)
local MomentsHostContext = require(Moments.MomentsHostContext)
local useMomentsHost = MomentsHostContext.useMomentsHost
local FFlagMomentsNavigationEvent = require(Moments.Flags.FFlagMomentsNavigationEvent)
local logFeedEndStateReached = require(Moments.Analytics.logFeedEndStateReached)
local makeFeedActionFields = require(Moments.Analytics.makeFeedActionFields)

local MomentMediaCoordinatorProvider = require(script.Parent.Media.MomentMediaCoordinatorProvider)
local SurfaceReadyTracker = require(script.Parent.SurfaceReadyTracker)
local SwipeLatencyTracker = require(script.Parent.SwipeLatencyTracker)

local verticalPager = VerticalPager.VerticalPager

local feedContext = FeedContext.FeedContext

local noopTelemetry = feedTelemetry.createNoopTelemetry()

local v = {
	deletedTitle = "Feature.Moments.Label.MomentDeletedTitle",
	deletedBody = "Feature.Moments.Label.MomentDeletedBody",
	deletedToast = "Feature.Moments.Label.PostDeleted"
}

local function renderFeedItem(p, p2: number)
	local feedItem = feedItemRegistry[p.kind]

	if feedItem == nil then
		return nil
	end

	return (feedItem.render(p, p2))
end

local function feedItemKey(p, p2: number)
	local feedItem = feedItemRegistry[p.kind]
	local selected

	if feedItem ~= nil then
		selected = feedItem.getKey(p)
	end

	if selected == nil or selected == "" then
		return (tostring(p2))
	end

	return selected
end

local function feedItemDedupeKey(p)
	local feedItem = feedItemRegistry[p.kind]

	if feedItem == nil then
		return nil
	end

	return (feedItem.getKey(p))
end

local function feedItemAttribution(p) -- 1 equivalent call inferred from this helper
	local feedItem = feedItemRegistry[p.kind]

	if feedItem == nil then
		return nil
	end

	return (feedItem.getAttribution(p))
end

local function withLimitReachedHidden(flag: boolean, pager)
	if FFlagMomentsParentTimeLimit then
		return React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			Visible = not flag,
			ZIndex = 1
		}, { Pager = pager })
	end

	return pager
end

local function stringOrNil(p) -- 2 equivalent calls inferred from this helper
	if p == nil then
		return nil
	end

	return (tostring(p))
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
	local itemId

	if recommendationMetadata ~= nil then
		itemId = recommendationMetadata.feedItemId
	end

	mediaLoadEventFields.itemId = itemId
	local tracingId

	if recommendationMetadata ~= nil then
		tracingId = recommendationMetadata.tracingId
	end

	mediaLoadEventFields.tracingId = tracingId
	mediaLoadEventFields.recommendationSource = source.recommendationSource or ""
	mediaLoadEventFields.feedSourceId = source.id or ""
	mediaLoadEventFields.placeId = stringOrNil(data.metadata.placeId) -- inferred equivalent call
	mediaLoadEventFields.universeId = stringOrNil(data.metadata.universeId) -- inferred equivalent call
	return mediaLoadEventFields
end

local logger = nil
local function getLogger() -- 2 equivalent calls inferred from this helper
	if logger == nil then
		local Loggers = require(parent.Loggers)
		logger = Loggers.Logger:new("Moments.Feed")
	end

	return logger
end

local function Feed(props)
	local source = props.source
	local isActiveFeed = props.active == nil or props.active
	local v2

	if props.playbackActive == nil then
		v2 = isActiveFeed
	else
		v2 = props.playbackActive
	end

	local v3 = props.showNavigationBar == nil or props.showNavigationBar
	local telemetry = props.telemetry or noopTelemetry
	local trackSurfaceLoad = props.trackSurfaceLoad == true
	local coveringOverlay, v4

	if FFlagMomentsComments and getCommentsSheetStore ~= nil then
		coveringOverlay = SignalsReact.useSignalState(getCommentsSheetStore(false).getIsOpen)

		v4 = SignalsReact.useSignalState(getCommentsSheetStore(false).getIsExpanded)
	else
		coveringOverlay = false
		v4 = false
	end

	local active = isActiveFeed and not coveringOverlay
	local v5

	if FFlagMomentsCreatorAnalytics and getPostInsightsPageStore ~= nil then
		v5 = SignalsReact.useSignalState(getPostInsightsPageStore(false).getIsOpen)

		if v5 then
			active = false
		end
	else
		v5 = false
	end

	local playbackActive

	if FFlagMomentsCreatorAnalytics and v5 then
		playbackActive = false
	else
		playbackActive = v2 and not v4
	end

	local immersiveChromeStore = GetImmersiveChromeStore(false)

	local v6 = useLocalization(v)

	local v7 = useMomentsSession()
	local toastStore = GetToastStore(false)
	local v8 = SignalsReact.useSignalState(v7.getPendingDeletion)

	local v9 = React.useMemo(function()
		local feedScrollLimit = getFeedScrollLimit(true, GetFFlagMomentsNonInfiniteScroll(), function()
			return GetMomentsCapabilities(false)
		end)
		local v9

		if FFlagMomentsParentTimeLimit then
			local GetMomentsUsageStore = require(Moments.Stores.GetMomentsUsageStore)
			v9 = GetMomentsUsageStore(false)
		end

		return createFeedStore(source, feedItemDedupeKey, trackSurfaceLoad, feedScrollLimit, v9)
	end, { source, trackSurfaceLoad })

	local v10 = v2
	React.useEffect(function()
		if FFlagMomentsParentTimeLimit and v10 then
			local GetMomentsUsageStore = require(Moments.Stores.GetMomentsUsageStore)
			local retainWatching = GetMomentsUsageStore(false).retainWatching()
			return function()
				retainWatching()
			end
		end
	end, { v10 })

	local v11 = SignalsReact.useSignalState(v9.getStatus)
	local v12 = FFlagMomentsParentTimeLimit and v11 == "LimitReached"

	if v12 then
		v2 = false
		playbackActive = false
	end

	React.useEffect(function()
		if not v12 then
			return
		end

		getExperienceDetailsSheetStore(false).close()

		if getCommentsSheetStore ~= nil then
			local commentsSheetStore = getCommentsSheetStore(false)

			if commentsSheetStore.getIsOpen(false) then
				commentsSheetStore.close("navigation_hidden")
			end
		end

		if getPostInsightsPageStore ~= nil then
			getPostInsightsPageStore(false).close()
		end
	end, { v12 })

	React.useEffect(function()
		v9.loadInitial()
		return function()
			v9.dispose()
		end
	end, { v9 })

	if FFlagMomentsCommentsCloseOnFeedJump and getCommentsSheetStore ~= nil then
		React.useEffect(function()
			if not isActiveFeed then
				return
			end

			local commentsSheetStore = getCommentsSheetStore(false)

			local function getCurrentPosition(p)
				local currentItem = v9.pager.getCurrentItem(p)

				if currentItem == nil or currentItem.kind == "skeleton" then
					return nil
				end

				if
					currentItem.kind ~= "moment"
					and (not FFlagMomentsRenderAvatarPostsInFeed or currentItem.kind ~= "avatarMoment")
				then
					return `kind:{currentItem.kind}`
				end

				local moment = currentItem.moment
				return moment.recommendationMetadata.feedItemId or `moment:{moment.momentId}`
			end

			local v13 = getCurrentPosition(false)
			return Signals.createEffect(function(p)
				local currentPosition = getCurrentPosition(p)

				if currentPosition == nil or currentPosition == v13 then
					return
				end

				local v14 = v13
				v13 = currentPosition

				if
					v14 ~= nil
					and commentsSheetStore.getIsOpen(false)
					and commentsSheetStore.getFeedItemId(false) == v14
				then
					commentsSheetStore.close()
				end
			end)
		end, { isActiveFeed, v9 })
	end

	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)

	local ref3 = React.useRef(nil)
	local analytics = React.useMemo(function()
		local v13 = {}
		function v13.onTargetCommitted(p: number, p2: number, p3)
			local current = ref2.current

			if current ~= nil then
				current(p, p2, p3)
			end
		end

		if FFlagMomentsNavigationEvent then
			function v13.onUserStep(p: number, p2: number)
				local current = ref3.current

				if current ~= nil then
					current(p, p2)
				end
			end
		end

		return v13
	end, {})
	local ref4 = React.useRef(0)
	local ref5 = React.useRef(false)
	local ref6 = React.useRef(0)

	local ref7 = React.useRef(nil)
	local refresh = React.useCallback(function(p)
		if ref5.current or DateTime.now().UnixTimestampMillis < ref4.current then
			return
		end

		local current = ref7.current

		if FFlagMomentsNavigationEvent and p ~= nil and current ~= nil then
			current(p)
		end

		ref5.current = true
		ref6.current += 1
		local current2 = ref6.current
		v9.refresh()

		task.spawn(function()
			while ref5.current and current2 == ref6.current do
				local status = v9.getStatus(false)

				if status == "Loaded" or status == "Empty" then
					ref5.current = false
					ref4.current = DateTime.now().UnixTimestampMillis + 1000
					break
				elseif status == "Failed" or FFlagMomentsParentTimeLimit and status == "LimitReached" then
					ref5.current = false
					break
				else
					task.wait()
				end
			end
		end)
	end, { v9 })

	local prependMoment = React.useCallback(function(moment)
		v9.prependItem({ kind = "moment", moment = moment })
		local current = ref.current

		if current ~= nil then
			current.scrollToIndex(1)
		end
	end, { v9 })

	local ref8 = React.useRef(nil)
	local v13 = useMomentsHost().openAvatarLookTryOn ~= nil
	local v14

	if FFlagMomentsPostInsightsIxpEnabled then
		v14 = source.recommendationSource or false
	else
		v14 = false
	end

	local onItemBecameActive = React.useCallback(function(p)
		if p.kind ~= "moment" and (not FFlagMomentsRenderAvatarPostsInFeed or p.kind ~= "avatarMoment") then
			return
		end

		local moment = p.moment

		if FFlagMomentsPostInsightsIxpEnabled then
			local logPostInsightsLayerExposure = require(Moments.Analytics.logPostInsightsLayerExposure)
			logPostInsightsLayerExposure(moment, source.recommendationSource)
		end

		local current = ref8.current

		local sessionSource = v7.getSessionSource(false)
		local v15

		if FFlagMomentsNavigationEvent and current ~= nil then
			v15 = current()
		end

		local v16

		if FFlagMomentsImpressionPrimaryEntity then
			v16 = v13
		end

		logMomentViewBegan(moment, sessionSource, v15, v16)
	end, { v7, v13, v14 })

	local includeRecommendationDetail = props.telemetry ~= nil
	local onViewEnded = React.useCallback(function(p, data)
		local makeMomentsNavigationFields = require(Moments.Analytics.makeMomentsNavigationFields)
		fireAnalyticsEvent(EventNames.MomentsNavigationEvent, makeMomentsNavigationFields({
			feedItemId = p.itemId,
			viewId = data.viewId,
			durationSeconds = data.durationSeconds,
			destinationType = data.destination,
			itemPosition = data.itemPosition,
			tracingId = p.tracingId,
			includeRecommendationDetail = includeRecommendationDetail,
			clientEventTimestampMs = DateTime.now().UnixTimestampMillis
		}))
	end, { includeRecommendationDetail })

	local onEndStateReached = React.useCallback(function(itemPosition: number)
		logFeedEndStateReached({
			source = v7.getSessionSource(false),
			recommendationSource = source.recommendationSource or "",
			feedSourceId = source.id or "",
			itemPosition = itemPosition
		})
	end, { v7, source })

	local pager = v9.pager
	local v15 = {
		telemetry = telemetry,
		active = isActiveFeed and not v12,
		getAttribution = feedItemAttribution,
		recommendationSource = source.recommendationSource,
		onItemBecameActive = onItemBecameActive,
		onEndStateReached = 0,
		onViewEnded = 0,
		inactiveDestination = 0
	}

	if not GetFFlagMomentsNonInfiniteScroll() and source.endsWithCaughtUp ~= true then
		onEndStateReached = nil
	end

	v15.onEndStateReached = onEndStateReached

	if not FFlagMomentsNavigationEvent then
		onViewEnded = nil
	end

	v15.onViewEnded = onViewEnded
	local inactiveDestination

	if FFlagMomentsNavigationEvent then
		inactiveDestination = props.inactiveDestination
	end

	v15.inactiveDestination = inactiveDestination
	local v16 = useFeedTelemetry(pager, v15)

	ref8.current = v16.getViewId
	ref7.current = v16.flushView
	ref3.current = v16.noteUserStep

	React.useImperativeHandle(props.controllerRef, function()
		return { prependMoment = prependMoment, refresh = refresh, flushView = v16.flushView }
	end, { prependMoment, refresh, v16.flushView })

	local ref9 = React.useRef(v2)
	React.useEffect(function()
		local current = ref9.current
		ref9.current = v2

		if v2 and not current then
			local currentItem = v9.pager.getCurrentItem(false)

			if currentItem ~= nil then
				onItemBecameActive(currentItem)
			end
		end
	end, { v2, v9, onItemBecameActive })

	local v17 = React.useCallback(function()
		local current = ref.current

		if current ~= nil then
			current.next()
		end
	end, {})
	local onScrollToPrevious = React.useCallback(function()
		local current = ref.current

		if current ~= nil then
			current.previous()
		end
	end, {})
	local v18, v19

	if FFlagMomentsOptimisticProfilePending then
		v18 = SignalsReact.useSignalState(v9.getInitialIndex)
		v19 = SignalsReact.useSignalState(v9.getError)
	end

	local current2 = SignalsReact.useSignalState(v9.getLoadMoreFailed)
	local ref10 = React.useRef({})

	React.useEffect(function()
		return function()
			ref6.current += 1
			ref5.current = false
			ref4.current = 0
		end
	end, { v9 })

	local ref11 = React.useRef(false)
	local ref12 = React.useRef(false)

	React.useEffect(function()
		if not ref11.current then
			ref11.current = true

			if trackSurfaceLoad then
				MomentsSurfaceLoadManager.renderStarted()
				MomentsSurfaceLoadManager.surfaceMounted()
			end

			local momentsFirstUIRenderedTimestamp = EventNames.MomentsFirstUIRenderedTimestamp
			local v20

			if trackSurfaceLoad and MomentsSurfaceLoadManager.isSessionActive() then
				v20 = MomentsSurfaceLoadManager.elapsedMs()
			else
				v20 = DateTime.now().UnixTimestampMillis
			end

			fireAnalyticsEvent(momentsFirstUIRenderedTimestamp, { value = v20 })
		end
	end, {})

	React.useEffect(function()
		if trackSurfaceLoad then
			return
		end

		if not ref12.current and (v11 == "Loaded" or v11 == "LoadingMore") then
			ref12.current = true
			fireAnalyticsEvent(EventNames.MomentsFirstContentLoadedTimestamp, {
				value = DateTime.now().UnixTimestampMillis
			})
		end
	end, { v11 })

	local ref13 = React.useRef(nil)

	React.useEffect(function()
		if v11 ~= ref13.current then
			if v11 == "Failed" then
				fireAnalyticsEvent(EventNames.FeedLoadFailed, {
					recommendationSource = source.recommendationSource or "",
					feedSourceId = source.id or "",
					failureReason = v9.getError(false) or ""
				})
			elseif v11 == "Empty" then
				fireAnalyticsEvent(EventNames.FeedNoMomentsFetched, {
					recommendationSource = source.recommendationSource or "",
					feedSourceId = source.id or ""
				})
			end
		end

		ref13.current = v11
	end, { v11 })

	local ref14 = React.useRef(false)

	React.useEffect(function()
		if current2 and not ref14.current then
			local v20 = v9.pager.getItems(false)[v9.pager.getCurrentIndex(false)]
			local v21

			if v20 ~= nil then
				v21 = feedItemAttribution(v20) -- inferred equivalent call
			end

			local feedLoadMoreFailed = EventNames.FeedLoadMoreFailed
			local v22 = {
				recommendationSource = source.recommendationSource or "",
				feedSourceId = source.id or "",
				itemId = 0,
				tracingId = 0
			}
			local itemId

			if v21 ~= nil then
				itemId = v21.itemId
			end

			v22.itemId = itemId
			local tracingId

			if v21 ~= nil then
				tracingId = v21.tracingId
			end

			v22.tracingId = tracingId
			fireAnalyticsEvent(feedLoadMoreFailed, v22)
		end

		ref14.current = current2
	end, { current2 })

	local removeCurrentItem = React.useCallback(function()
		local currentIndex = v9.pager.getCurrentIndex(false)
		local current = ref.current

		if current ~= nil then
			current.removeItem(currentIndex)
		end
	end, { v9 })

	local onConfirm = React.useCallback(function()
		if v8 then
			local momentId = v8.momentId
			local feedItemId = v8.feedItemId
			local feedSessionId = v8.feedSessionId

			if feedItemId == nil or feedItemId == "" then
				v7.clearPendingDeletion()
				return
			end

			task.spawn(function()
				local v20, v21 = deleteMoment(feedItemId):await()

				if not v20 then
					getLogger():warning("Failed to delete moment {}: {}", momentId, (tostring(v21))) -- inferred equivalent call
				end
			end)
			removeCurrentItem()

			if FFlagMomentsRemoveDeletedFromProfile or FFlagMomentsOptimisticProfilePending then
				GetDeletedMomentsStore(false).markDeleted(momentId)
			end

			local feedActionFields = makeFeedActionFields(momentId, feedItemId, feedSessionId, "delete")

			if feedActionFields then
				fireAnalyticsEvent(EventNames.MomentItemDeleted, feedActionFields)
			end

			if FFlagMomentsDeleteSnackbar then
				toastStore.triggerToast({ title = v6.deletedToast, text = "", variant = "snackbar" })
			elseif FFlagMomentsFixDeleteToastCopy then
				toastStore.triggerToast({ title = v6.deletedToast, text = "" })
			else
				toastStore.triggerToast({ title = v6.deletedTitle, text = v6.deletedBody })
			end
		end

		v7.clearPendingDeletion()
	end, { v8, v7, toastStore, v6, removeCurrentItem })

	local onCancel = React.useCallback(function()
		v7.clearPendingDeletion()
	end, { v7 })

	local v20 = React.useCallback(function(data, failureReason: string?)
		getLogger():debug( -- inferred equivalent call
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

		fireAnalyticsEvent(EventNames.FeedMediaLoadFailed, mediaLoadEventFields)
	end, { source })

	local v21 = React.useCallback(function(p: string, p2: string?)
		if ref10.current[p] then
			return
		end

		local items = v9.pager.getItems(false)

		for k, item in items do
			if
				(item.kind == "moment" or FFlagMomentsRenderAvatarPostsInFeed and item.kind == "avatarMoment")
				and item.moment.momentId == p
			then
				ref10.current[p] = true
				v20(item.moment, p2)
				local current = ref.current

				if current == nil then
					v9.pager.removeItem(k)
				else
					current.removeItem(k)
				end

				break
			end
		end
	end, { v9, v20 })

	local onMediaItemLoadAttempted = React.useCallback(function(p: string)
		Analytics.reportMomentsFeedMediaLoad("attempted", v9.observabilityFeedType)

		if FFlagMomentsFeedMediaLoadAttemptedEvent then
			for _, v22 in v9.pager.getItems(false) do
				if v22.kind == "moment" and v22.moment.momentId == p then
					fireAnalyticsEvent(EventNames.FeedMediaLoadAttempted, makeMediaLoadEventFields(v22.moment, source))
					return
				end
			end
		end
	end, { v9, source })

	local onMediaItemFailed = React.useCallback(function(p: string, p2: string?)
		Analytics.reportMomentsFeedMediaLoad("failed", v9.observabilityFeedType, p2)
		v21(p, p2)
	end, { v9, v21 })

	local v22 = React.useMemo(function()
		local v22 = {
			getStatus = v9.getStatus,
			isActiveFeed = isActiveFeed,
			isPlaybackActive = v2,
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
		local getCurrentIndex

		if FFlagMomentsRenderAvatarPostsInFeed then
			getCurrentIndex = v9.pager.getCurrentIndex
		end

		v22.getCurrentIndex = getCurrentIndex
		local getCurrentItem

		if FFlagMomentsCommentDeepLinks then
			getCurrentItem = v9.pager.getCurrentItem
		end

		v22.getCurrentItem = getCurrentItem
		v22.recommendationSource = source.recommendationSource
		function v22.logAction(p, p2, p3)
			return telemetry.logAction(p, p2, p3)
		end

		v22.flushView = v16.flushView

		v22.getChromeVisible = immersiveChromeStore.getChromeVisible
		v22.revealChrome = immersiveChromeStore.revealChrome
		v22.removeCurrentItem = removeCurrentItem
		v22.scrollToNext = v17
		local loadMoreBeyondLimit

		if GetFFlagMomentsNonInfiniteScroll() then
			loadMoreBeyondLimit = v9.loadBeyondLimit
		end

		v22.loadMoreBeyondLimit = loadMoreBeyondLimit
		v22.getCanLoadMoreBeyondLimit = v9.getCanLoadMoreBeyondLimit
		v22.caughtUpState = props.caughtUpState
		return v22
	end, {
		v9,
		isActiveFeed,
		v2,
		source,
		telemetry,
		v16.flushView,
		immersiveChromeStore,
		removeCurrentItem,
		v17,
		props.caughtUpState
	})

	local v23 = v11 == "Loaded" or v11 == "LoadingMore"
	local active2

	if active then
		if v11 == "Failed" or v11 == "Empty" then
			active2 = false
		else
			active2 = not v12
		end
	else
		active2 = active
	end

	local createElement = React.createElement
	local provider = feedContext.Provider

	local createElement2 = React.createElement
	local v24 = {
		AnchorPoint = props.AnchorPoint,
		BackgroundTransparency = 1,
		LayoutOrder = props.LayoutOrder,
		Position = props.Position,
		Size = props.Size or UDim2.fromScale(1, 1),
		ZIndex = props.ZIndex
	}

	local createElement3 = React.createElement
	local v25 = {
		store = v9.pager,
		renderItem = renderFeedItem,
		keyExtractor = feedItemKey,
		analytics = analytics,
		onEndReached = v9.loadMore,
		active = active2,
		controllerRef = ref,
		initialIndex = 0,
		tuning = 0,
		Size = 0,
		ZIndex = 1
	}
	local initialIndex

	if FFlagMomentsOptimisticProfilePending then
		initialIndex = v18 or props.initialIndex
	else
		initialIndex = props.initialIndex
	end

	v25.initialIndex = initialIndex

	v25.tuning = props.pager
	v25.Size = UDim2.fromScale(1, 1)
	local children = {
		Pager = withLimitReachedHidden(v12, createElement3(verticalPager, v25)),
		StateOverlay = React.createElement(FeedStateView, {
			status = v11,
			loadMoreFailed = current2 or FFlagMomentsOptimisticProfilePending and v19 ~= nil,
			onRetry = v9.retry,
			emptyContent = props.emptyContent,
			emptyState = props.emptyState,
			zIndex = 2
		}),
		NavBar = 0,
		ImmersiveController = 0,
		SwipeLatency = 0,
		DeletionDialog = 0
	}
	local navBar

	if v3 and v23 then
		navBar = React.createElement(FeedNavigationBar, {
			pager = v9.pager,
			active = active,
			onScrollToNext = v17,
			onScrollToPrevious = onScrollToPrevious,
			zIndex = 3
		})
	end

	children.NavBar = navBar

	children.ImmersiveController = React.createElement(ImmersiveChromeController, {
		pager = v9.pager,
		active = isActiveFeed and v2,
		controllerRef = ref,
		coveringOverlay = coveringOverlay
	})

	children.SwipeLatency = React.createElement(SwipeLatencyTracker, {
		pager = v9.pager,
		controllerRef = ref,
		onTargetCommittedRef = ref2
	})
	local deletionDialog

	if v8 ~= nil then
		deletionDialog = React.createElement(DeletionConfirmationDialog, {
			onCancel = onCancel,
			onConfirm = onConfirm
		})
	end

	children.DeletionDialog = deletionDialog
	local element = createElement(provider, { value = v22 }, {
		Root = createElement2("Frame", v24, children)
	})

	return React.createElement(MomentMediaCoordinatorProvider, {
		pager = v9.pager,
		playbackActive = playbackActive,
		createCoordinator = props.createCoordinator,
		onMediaItemLoadAttempted = onMediaItemLoadAttempted,
		onMediaItemFailed = onMediaItemFailed
	}, trackSurfaceLoad and {
		Feed = element,
		SurfaceReadyTracker = React.createElement(SurfaceReadyTracker, { pager = v9.pager })
	} or element)
end

return Feed
