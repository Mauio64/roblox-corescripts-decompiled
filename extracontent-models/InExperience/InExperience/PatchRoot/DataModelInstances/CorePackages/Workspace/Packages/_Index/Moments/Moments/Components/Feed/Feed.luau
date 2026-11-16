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
	local v2 = props.active == nil or props.active
	local v3

	if props.playbackActive == nil then
		v3 = v2
	else
		v3 = props.playbackActive
	end

	local v4 = props.showNavigationBar == nil or props.showNavigationBar
	local telemetry = props.telemetry or noopTelemetry
	local trackSurfaceLoad = props.trackSurfaceLoad == true
	local coveringOverlay, v5

	if FFlagMomentsComments and getCommentsSheetStore ~= nil then
		coveringOverlay = SignalsReact.useSignalState(getCommentsSheetStore(false).getIsOpen)

		v5 = SignalsReact.useSignalState(getCommentsSheetStore(false).getIsExpanded)
	else
		coveringOverlay = false
		v5 = false
	end

	local active = v2 and not coveringOverlay
	local v6

	if FFlagMomentsCreatorAnalytics and getPostInsightsPageStore ~= nil then
		v6 = SignalsReact.useSignalState(getPostInsightsPageStore(false).getIsOpen)

		if v6 then
			active = false
		end
	else
		v6 = false
	end

	local playbackActive

	if FFlagMomentsCreatorAnalytics and v6 then
		playbackActive = false
	else
		playbackActive = v3 and not v5
	end

	local immersiveChromeStore = GetImmersiveChromeStore(false)

	local v7 = useLocalization(v)

	local v8 = useMomentsSession()
	local toastStore = GetToastStore(false)
	local v9 = SignalsReact.useSignalState(v8.getPendingDeletion)

	local v10 = React.useMemo(function()
		return createFeedStore(
			source,
			feedItemDedupeKey,
			trackSurfaceLoad,
			(getFeedScrollLimit(true, GetFFlagMomentsNonInfiniteScroll(), function()
				return GetMomentsCapabilities(false)
			end))
		)
	end, { source, trackSurfaceLoad })

	React.useEffect(function()
		v10.loadInitial()
		return function()
			v10.dispose()
		end
	end, { v10 })

	if FFlagMomentsCommentsCloseOnFeedJump and getCommentsSheetStore ~= nil then
		React.useEffect(function()
			if not v2 then
				return
			end

			local commentsSheetStore = getCommentsSheetStore(false)

			local function getCurrentPosition(p)
				local currentItem = v10.pager.getCurrentItem(p)

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

			local v11 = getCurrentPosition(false)
			return Signals.createEffect(function(p)
				local currentPosition = getCurrentPosition(p)

				if currentPosition == nil or currentPosition == v11 then
					return
				end

				local v12 = v11
				v11 = currentPosition

				if
					v12 ~= nil
					and commentsSheetStore.getIsOpen(false)
					and commentsSheetStore.getFeedItemId(false) == v12
				then
					commentsSheetStore.close()
				end
			end)
		end, { v2, v10 })
	end

	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)

	local ref3 = React.useRef(nil)
	local analytics = React.useMemo(function()
		local v11 = {}
		function v11.onTargetCommitted(p: number, p2: number, p3)
			local current = ref2.current

			if current ~= nil then
				current(p, p2, p3)
			end
		end

		if FFlagMomentsNavigationEvent then
			function v11.onUserStep(p: number, p2: number)
				local current = ref3.current

				if current ~= nil then
					current(p, p2)
				end
			end
		end

		return v11
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
		v10.refresh()

		task.spawn(function()
			while ref5.current and current2 == ref6.current do
				local status = v10.getStatus(false)

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
	end, { v10 })

	local prependMoment = React.useCallback(function(moment)
		v10.prependItem({ kind = "moment", moment = moment })
		local current = ref.current

		if current ~= nil then
			current.scrollToIndex(1)
		end
	end, { v10 })

	local ref8 = React.useRef(nil)
	local v11 = useMomentsHost().openAvatarLookTryOn ~= nil
	local onItemBecameActive = React.useCallback(function(p)
		if p.kind ~= "moment" and (not FFlagMomentsRenderAvatarPostsInFeed or p.kind ~= "avatarMoment") then
			return
		end

		local moment = p.moment
		local current = ref8.current

		local sessionSource = v8.getSessionSource(false)
		local v12

		if FFlagMomentsNavigationEvent and current ~= nil then
			v12 = current()
		end

		local v13

		if FFlagMomentsImpressionPrimaryEntity then
			v13 = v11
		end

		logMomentViewBegan(moment, sessionSource, v12, v13)
	end, { v8, v11 })

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
			source = v8.getSessionSource(false),
			recommendationSource = source.recommendationSource or "",
			feedSourceId = source.id or "",
			itemPosition = itemPosition
		})
	end, { v8, source })

	local pager = v10.pager
	local v12 = {
		telemetry = telemetry,
		active = v2,
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

	v12.onEndStateReached = onEndStateReached

	if not FFlagMomentsNavigationEvent then
		onViewEnded = nil
	end

	v12.onViewEnded = onViewEnded
	local inactiveDestination

	if FFlagMomentsNavigationEvent then
		inactiveDestination = props.inactiveDestination
	end

	v12.inactiveDestination = inactiveDestination
	local v13 = useFeedTelemetry(pager, v12)

	ref8.current = v13.getViewId
	ref7.current = v13.flushView
	ref3.current = v13.noteUserStep

	React.useImperativeHandle(props.controllerRef, function()
		return { prependMoment = prependMoment, refresh = refresh, flushView = v13.flushView }
	end, { prependMoment, refresh, v13.flushView })

	local ref9 = React.useRef(v3)
	React.useEffect(function()
		local current = ref9.current
		ref9.current = v3

		if v3 and not current then
			local currentItem = v10.pager.getCurrentItem(false)

			if currentItem ~= nil then
				onItemBecameActive(currentItem)
			end
		end
	end, { v3, v10, onItemBecameActive })

	local v14 = React.useCallback(function()
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

	local v15 = SignalsReact.useSignalState(v10.getStatus)
	local v16, v17

	if FFlagMomentsOptimisticProfilePending then
		v16 = SignalsReact.useSignalState(v10.getInitialIndex)
		v17 = SignalsReact.useSignalState(v10.getError)
	end

	local current2 = SignalsReact.useSignalState(v10.getLoadMoreFailed)
	local ref10 = React.useRef({})

	React.useEffect(function()
		return function()
			ref6.current += 1
			ref5.current = false
			ref4.current = 0
		end
	end, { v10 })

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
			local v18

			if trackSurfaceLoad and MomentsSurfaceLoadManager.isSessionActive() then
				v18 = MomentsSurfaceLoadManager.elapsedMs()
			else
				v18 = DateTime.now().UnixTimestampMillis
			end

			fireAnalyticsEvent(momentsFirstUIRenderedTimestamp, { value = v18 })
		end
	end, {})

	React.useEffect(function()
		if trackSurfaceLoad then
			return
		end

		if not ref12.current and (v15 == "Loaded" or v15 == "LoadingMore") then
			ref12.current = true
			fireAnalyticsEvent(EventNames.MomentsFirstContentLoadedTimestamp, {
				value = DateTime.now().UnixTimestampMillis
			})
		end
	end, { v15 })

	local ref13 = React.useRef(nil)

	React.useEffect(function()
		if v15 ~= ref13.current then
			if v15 == "Failed" then
				fireAnalyticsEvent(EventNames.FeedLoadFailed, {
					recommendationSource = source.recommendationSource or "",
					feedSourceId = source.id or "",
					failureReason = v10.getError(false) or ""
				})
			elseif v15 == "Empty" then
				fireAnalyticsEvent(EventNames.FeedNoMomentsFetched, {
					recommendationSource = source.recommendationSource or "",
					feedSourceId = source.id or ""
				})
			end
		end

		ref13.current = v15
	end, { v15 })

	local ref14 = React.useRef(false)

	React.useEffect(function()
		if current2 and not ref14.current then
			local v18 = v10.pager.getItems(false)[v10.pager.getCurrentIndex(false)]
			local v19

			if v18 ~= nil then
				v19 = feedItemAttribution(v18) -- inferred equivalent call
			end

			local feedLoadMoreFailed = EventNames.FeedLoadMoreFailed
			local v20 = {
				recommendationSource = source.recommendationSource or "",
				feedSourceId = source.id or "",
				itemId = 0,
				tracingId = 0
			}
			local itemId

			if v19 ~= nil then
				itemId = v19.itemId
			end

			v20.itemId = itemId
			local tracingId

			if v19 ~= nil then
				tracingId = v19.tracingId
			end

			v20.tracingId = tracingId
			fireAnalyticsEvent(feedLoadMoreFailed, v20)
		end

		ref14.current = current2
	end, { current2 })

	local removeCurrentItem = React.useCallback(function()
		local currentIndex = v10.pager.getCurrentIndex(false)
		local current = ref.current

		if current ~= nil then
			current.removeItem(currentIndex)
		end
	end, { v10 })

	local onConfirm = React.useCallback(function()
		if v9 then
			local momentId = v9.momentId
			local feedItemId = v9.feedItemId
			local feedSessionId = v9.feedSessionId

			if feedItemId == nil or feedItemId == "" then
				v8.clearPendingDeletion()
				return
			end

			task.spawn(function()
				local v18, v19 = deleteMoment(feedItemId):await()

				if not v18 then
					getLogger():warning("Failed to delete moment {}: {}", momentId, (tostring(v19))) -- inferred equivalent call
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
				toastStore.triggerToast({ title = v7.deletedToast, text = "", variant = "snackbar" })
			elseif FFlagMomentsFixDeleteToastCopy then
				toastStore.triggerToast({ title = v7.deletedToast, text = "" })
			else
				toastStore.triggerToast({ title = v7.deletedTitle, text = v7.deletedBody })
			end
		end

		v8.clearPendingDeletion()
	end, { v9, v8, toastStore, v7, removeCurrentItem })

	local onCancel = React.useCallback(function()
		v8.clearPendingDeletion()
	end, { v8 })

	local v18 = React.useCallback(function(data, failureReason: string?)
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

	local v19 = React.useCallback(function(p: string, p2: string?)
		if ref10.current[p] then
			return
		end

		local items = v10.pager.getItems(false)

		for k, item in items do
			if
				(item.kind == "moment" or FFlagMomentsRenderAvatarPostsInFeed and item.kind == "avatarMoment")
				and item.moment.momentId == p
			then
				ref10.current[p] = true
				v18(item.moment, p2)
				local current = ref.current

				if current == nil then
					v10.pager.removeItem(k)
				else
					current.removeItem(k)
				end

				break
			end
		end
	end, { v10, v18 })

	local onMediaItemLoadAttempted = React.useCallback(function(p: string)
		Analytics.reportMomentsFeedMediaLoad("attempted", v10.observabilityFeedType)

		if FFlagMomentsFeedMediaLoadAttemptedEvent then
			for _, v20 in v10.pager.getItems(false) do
				if v20.kind == "moment" and v20.moment.momentId == p then
					fireAnalyticsEvent(EventNames.FeedMediaLoadAttempted, makeMediaLoadEventFields(v20.moment, source))
					return
				end
			end
		end
	end, { v10, source })

	local onMediaItemFailed = React.useCallback(function(p: string, p2: string?)
		Analytics.reportMomentsFeedMediaLoad("failed", v10.observabilityFeedType, p2)
		v19(p, p2)
	end, { v10, v19 })

	local v20 = React.useMemo(function()
		local v20 = {
			getStatus = v10.getStatus,
			isActiveFeed = v2,
			isPlaybackActive = v3,
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
			getCurrentIndex = v10.pager.getCurrentIndex
		end

		v20.getCurrentIndex = getCurrentIndex
		local getCurrentItem

		if FFlagMomentsCommentDeepLinks then
			getCurrentItem = v10.pager.getCurrentItem
		end

		v20.getCurrentItem = getCurrentItem
		v20.recommendationSource = source.recommendationSource
		function v20.logAction(p, p2, p3)
			return telemetry.logAction(p, p2, p3)
		end

		v20.flushView = v13.flushView

		v20.getChromeVisible = immersiveChromeStore.getChromeVisible
		v20.revealChrome = immersiveChromeStore.revealChrome
		v20.removeCurrentItem = removeCurrentItem
		v20.scrollToNext = v14
		local loadMoreBeyondLimit

		if GetFFlagMomentsNonInfiniteScroll() then
			loadMoreBeyondLimit = v10.loadBeyondLimit
		end

		v20.loadMoreBeyondLimit = loadMoreBeyondLimit
		v20.getCanLoadMoreBeyondLimit = v10.getCanLoadMoreBeyondLimit
		v20.caughtUpState = props.caughtUpState
		return v20
	end, {
		v10,
		v2,
		v3,
		source,
		telemetry,
		v13.flushView,
		immersiveChromeStore,
		removeCurrentItem,
		v14,
		props.caughtUpState
	})

	local v21 = v15 == "Loaded" or v15 == "LoadingMore"
	local active2

	if active then
		if v15 == "Failed" then
			active2 = false
		else
			active2 = v15 ~= "Empty"
		end
	else
		active2 = active
	end

	local createElement = React.createElement
	local provider = feedContext.Provider

	local createElement2 = React.createElement
	local v22 = {
		AnchorPoint = props.AnchorPoint,
		BackgroundTransparency = 1,
		LayoutOrder = props.LayoutOrder,
		Position = props.Position,
		Size = props.Size or UDim2.fromScale(1, 1),
		ZIndex = props.ZIndex
	}

	local createElement3 = React.createElement
	local v23 = {
		store = v10.pager,
		renderItem = renderFeedItem,
		keyExtractor = feedItemKey,
		analytics = analytics,
		onEndReached = v10.loadMore,
		active = active2,
		controllerRef = ref,
		initialIndex = 0,
		tuning = 0,
		Size = 0,
		ZIndex = 1
	}
	local initialIndex

	if FFlagMomentsOptimisticProfilePending then
		initialIndex = v16 or props.initialIndex
	else
		initialIndex = props.initialIndex
	end

	v23.initialIndex = initialIndex

	v23.tuning = props.pager
	v23.Size = UDim2.fromScale(1, 1)
	local children = {
		Pager = createElement3(verticalPager, v23),
		StateOverlay = React.createElement(FeedStateView, {
			status = v15,
			loadMoreFailed = current2 or FFlagMomentsOptimisticProfilePending and v17 ~= nil,
			onRetry = v10.retry,
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

	if v4 and v21 then
		navBar = React.createElement(FeedNavigationBar, {
			pager = v10.pager,
			active = active,
			onScrollToNext = v14,
			onScrollToPrevious = onScrollToPrevious,
			zIndex = 3
		})
	end

	children.NavBar = navBar

	children.ImmersiveController = React.createElement(ImmersiveChromeController, {
		pager = v10.pager,
		active = v2 and v3,
		controllerRef = ref,
		coveringOverlay = coveringOverlay
	})

	children.SwipeLatency = React.createElement(SwipeLatencyTracker, {
		pager = v10.pager,
		controllerRef = ref,
		onTargetCommittedRef = ref2
	})
	local deletionDialog

	if v9 ~= nil then
		deletionDialog = React.createElement(DeletionConfirmationDialog, {
			onCancel = onCancel,
			onConfirm = onConfirm
		})
	end

	children.DeletionDialog = deletionDialog
	local element = createElement(provider, { value = v20 }, {
		Root = createElement2("Frame", v22, children)
	})

	return React.createElement(MomentMediaCoordinatorProvider, {
		pager = v10.pager,
		playbackActive = playbackActive,
		createCoordinator = props.createCoordinator,
		onMediaItemLoadAttempted = onMediaItemLoadAttempted,
		onMediaItemFailed = onMediaItemFailed
	}, trackSurfaceLoad and {
		Feed = element,
		SurfaceReadyTracker = React.createElement(SurfaceReadyTracker, { pager = v10.pager })
	} or element)
end

return Feed
