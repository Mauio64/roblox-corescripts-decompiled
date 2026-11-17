local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)
local ViewRecycler = require(parent.ViewRecycler)
local MomentsCommon = require(parent.MomentsCommon)
local SharedFlags = require(parent.SharedFlags)
local FFlagMomentsComments = SharedFlags.FFlagMomentsComments
local FFlagMomentsCommentActionsRealtime = require(Moments.Flags.FFlagMomentsCommentActionsRealtime)
local FFlagMomentsCommentTranslation = require(Moments.Flags.FFlagMomentsCommentTranslation)
local FFlagMomentsCommentTranslationShownByDefault = require(Moments.Flags.FFlagMomentsCommentTranslationShownByDefault)
local FFlagMomentsCommentsRevealAfterMeasure = require(Moments.Flags.FFlagMomentsCommentsRevealAfterMeasure)
local FFlagMomentsCommentsScrollToPostedComment = require(Moments.Flags.FFlagMomentsCommentsScrollToPostedComment)
local FFlagMomentsCommentsAttachSheetScroller = require(Moments.Flags.FFlagMomentsCommentsAttachSheetScroller)
local EventNames = MomentsCommon.Analytics.EventNames

local MomentsGetMomentsCommentsStore = require(parent.DataHydration.MomentsGetMomentsCommentsStore)
local MomentsGetMomentsReactionsStore = require(parent.DataHydration.MomentsGetMomentsReactionsStore)
local MomentsResolveEmoteId = require(parent.DataHydration.MomentsResolveEmoteId)
require(parent.MomentsTypes)
local GetCommentCollectionStore = require(Moments.Components.Comments.GetCommentCollectionStore)
local CommentCollectionTypes = require(Moments.Components.Comments.GetCommentCollectionStore.CommentCollectionTypes)
local getCommentsListCoordinator = require(script.Parent.Parent.getCommentsListCoordinator)
local getCommentsSheetStore = require(Moments.Components.Comments.Sheet.getCommentsSheetStore)
local useCommentCapabilities = require(Moments.Components.Comments.useCommentCapabilities)
local GetToastStore = require(Moments.Stores.GetToastStore)
local MomentsHostContext = require(Moments.MomentsHostContext)
local useMomentsHost = MomentsHostContext.useMomentsHost
local ReactionType = require(Moments.Enums.ReactionType)
local buildCommentRows = require(script.Parent.Parent.Rows.buildCommentRows)
require(script.Parent.Parent.Rows.CommentRowTypes)
local CommentsListItems = require(script.Parent.CommentsListItems)
require(script.Parent.CommentsListRowContext)
require(script.Parent.CommentsListView)
local createExpandedCommentsStore = require(script.Parent.createExpandedCommentsStore)
local createToggledTranslationsStore = require(script.Parent.createToggledTranslationsStore)
local useCommentsListReveal = require(script.Parent.useCommentsListReveal)

local Players = game:GetService("Players")

local LoadStatus = CommentCollectionTypes.LoadStatus
local useLocalization = Localization.Hooks.useLocalization

local v = { deleteFailed = "Feature.Moments.Label.CommentDeleteFailed" }

local function showDeleteFailedToast(deleteFailed: string) -- 1 equivalent call inferred from this helper
	GetToastStore(false).triggerToast({ title = deleteFailed, text = "" })
end

local function useCommentsListViewModel(data)
	local deleteFailed = useLocalization(v).deleteFailed
	local localPlayer = Players.LocalPlayer
	local viewerUsername = localPlayer == nil and "" or localPlayer.Name
	local commentCollectionStore = GetCommentCollectionStore(false)
	local v2 = React.useMemo(function()
		return commentCollectionStore.getState(data.feedItemId)
	end, { commentCollectionStore, data.feedItemId })
	local v3 = SignalsReact.useSignalState(v2)

	local v4 = React.useState(createExpandedCommentsStore)
	local getExpandedCommentIds = v4.getExpandedCommentIds
	local v5

	if FFlagMomentsCommentTranslation then
		v5 = React.useState(createToggledTranslationsStore)
	else
		v5 = nil
	end

	local getToggledCommentIds

	if v5 == nil then
		getToggledCommentIds = nil
	else
		getToggledCommentIds = v5.getToggledCommentIds
	end

	local v6 = React.useMemo(function()
		local previousRows = nil
		return Signals.createComputed(function(p)
			local commentRows = buildCommentRows({
				state = v2(p),
				resolveComment = function(p2)
					return MomentsGetMomentsCommentsStore(false).getCachedComment(p2).data(p)
				end,
				previousRows = previousRows,
				expandedCommentIds = getExpandedCommentIds(p),
				translation = getToggledCommentIds ~= nil and {
					showsTranslationByDefault = FFlagMomentsCommentTranslationShownByDefault,
					toggledCommentIds = getToggledCommentIds(p)
				} or nil
			})

			previousRows = commentRows
			return commentRows
		end)
	end, { v2, getExpandedCommentIds, getToggledCommentIds or false })
	local v7 = SignalsReact.useSignalState(v6)
	local momentsGetMomentsCommentsStore = MomentsGetMomentsCommentsStore(false)
	local v8 = React.useMemo(function()
		return momentsGetMomentsCommentsStore.getCachedMomentComments(data.feedItemId)
	end, { momentsGetMomentsCommentsStore, data.feedItemId })
	local v9 = SignalsReact.useSignalState(v8.data)

	local momentsGetMomentsReactionsStore = MomentsGetMomentsReactionsStore(false)
	local v10 = React.useMemo(function()
		return Signals.createComputed(function(p)
			local getCachedEmojiCatalog = momentsGetMomentsReactionsStore.getCachedEmojiCatalog

			if getCachedEmojiCatalog == nil then
				return nil
			end

			local cachedEmojiCatalog = getCachedEmojiCatalog(p)

			if cachedEmojiCatalog.source == "cache" and cachedEmojiCatalog.status == "Ready" then
				return MomentsResolveEmoteId.resolveOptionalEmoteIdForReaction(
					cachedEmojiCatalog.emojis,
					ReactionType.ThumbsUp
				)
			end

			return nil
		end)
	end, { momentsGetMomentsReactionsStore })
	local thumbsUpEmoteId = SignalsReact.useSignalState(v10)

	if not useCommentCapabilities().canReact then
		thumbsUpEmoteId = nil
	end

	local v11 = Foundation.Hooks.useTokens()

	local small = v11.Padding.Small

	local size_2000 = v11.Size.Size_2000
	local layout = React.useState(function()
		return ViewRecycler.Layout.measured({ estimatedItemLength = size_2000 })
	end)

	React.useEffect(function()
		return function()
			layout.destroy()
		end
	end, { layout })

	local loadMoreStatus = v3.loadMoreStatus
	local isReadOnly = data.isReadOnly
	local items = React.useMemo(function()
		local result = table.create(#v7 + 2)

		for k, v12 in v7 do
			result[k] = v12
		end

		if loadMoreStatus == LoadStatus.Loading or loadMoreStatus == LoadStatus.Failed then
			table.insert(result, CommentsListItems.loadMore(loadMoreStatus))
		end

		if isReadOnly then
			table.insert(result, CommentsListItems.readOnlyNotice())
		end

		return result
	end, { v7, loadMoreStatus, isReadOnly })
	local v12 = React.useMemo(function()
		return { items = items, getItemKey = CommentsListItems.getItemKey }
	end, { items })

	local v13 = nil
	local onVisibleItemsPresented = nil

	if FFlagMomentsCommentsRevealAfterMeasure and FFlagMomentsCommentsAttachSheetScroller then
		local ref = React.useRef(data.onRevealed)
		ref.current = data.onRevealed
		onVisibleItemsPresented = React.useCallback(function()
			local current = ref.current

			if current ~= nil then
				current()
			end
		end, {})

		React.useEffect(function()
			local thread = task.delay(1, onVisibleItemsPresented)
			return function()
				pcall(task.cancel, thread)
			end
		end, { onVisibleItemsPresented })
	elseif FFlagMomentsCommentsRevealAfterMeasure then
		v13 = useCommentsListReveal(layout, items, data.onRevealed)
	end

	local commentsListCoordinator = getCommentsListCoordinator(false)
	local v14 = React.useCallback(function()
		return commentsListCoordinator.loadMore(data.feedItemId, data.sessionId)
	end, { commentsListCoordinator, data.feedItemId, data.sessionId })
	local onEndReached = React.useCallback(function()
		v14()
	end, { v14 })

	local ref = React.useRef(0)
	local ref2 = React.useRef(0)
	local v15 = React.useCallback(function()
		if ref.current > 0 and ref2.current > 0 and ref2.current <= ref.current then
			v14()
		end
	end, { v14 })
	local onViewportChanged = React.useCallback(function(vector2: Vector2)
		ref.current = vector2.Y
		v15()
	end, { v15 })
	local onContentLengthChanged = React.useCallback(function(current: number)
		ref2.current = current
		v15()
	end, { v15 })

	local onRetryLoadMore = React.useCallback(function()
		commentsListCoordinator.retryLoadMore(data.feedItemId, data.sessionId)
	end, { commentsListCoordinator, data.feedItemId, data.sessionId })
	local onRetryPendingSubmission = React.useCallback(function()
		commentsListCoordinator.retryPendingSubmission(data.feedItemId, data.sessionId)
	end, { commentsListCoordinator, data.feedItemId, data.sessionId })
	local onEditPendingSubmission = React.useCallback(function()
		commentsListCoordinator.editPendingSubmission(data.feedItemId, data.sessionId)
	end, { commentsListCoordinator, data.feedItemId, data.sessionId })
	local v16

	if FFlagMomentsComments then
		v16 = getCommentsSheetStore(false).getAnalyticsSession(data.feedItemId, data.sessionId)
	else
		v16 = nil
	end

	local onToggleReaction = React.useCallback(function(commentId: string, p: string, p2, flag: boolean)
		if FFlagMomentsComments and v16 ~= nil then
			v16.logEvent(EventNames.MomentCommentReactButtonClicked, {
				commentId = commentId,
				reactionSelected = tostring(not flag)
			})
		end

		if flag then
			return commentsListCoordinator.ensureReactionAbsent(data.feedItemId, commentId, p, p2)
		end

		return commentsListCoordinator.ensureReactionPresent(data.feedItemId, commentId, p, p2)
	end, { commentsListCoordinator, data.feedItemId, v16 })

	local onAddReaction = React.useCallback(function(p: string, p2: string, p3)
		return commentsListCoordinator.ensureReactionPresent(data.feedItemId, p, p2, p3)
	end, { commentsListCoordinator, data.feedItemId })
	local onToggleCommentTranslation

	if FFlagMomentsCommentTranslation then
		onToggleCommentTranslation = React.useCallback(function(commentId: string)
			local v17 = v5.getToggledCommentIds(false)[commentId] ~= true
			v5.toggle(commentId)

			if v16 ~= nil then
				v16.logEvent(EventNames.MomentCommentTranslationToggled, {
					commentId = commentId,
					isTranslationShown = tostring(v17 ~= FFlagMomentsCommentTranslationShownByDefault)
				})
			end
		end, { v5, v16 })
	else
		onToggleCommentTranslation = nil
	end

	local v17 = useMomentsHost()
	local openMomentCommentReport = v17.openMomentCommentReport
	local channelId = v3.channelId
	local onReportComment = React.useMemo(function()
		if openMomentCommentReport == nil or channelId == nil then
			return nil
		end

		return function(commentId: string, reportedUserId: string)
			if FFlagMomentsComments and v16 ~= nil then
				v16.logEvent(EventNames.MomentCommentReportClicked, { commentId = commentId })
			end

			if FFlagMomentsCommentActionsRealtime and v16 ~= nil then
				v16.logRealtimeEvent("MomentsCommentReport", { status = "clicked" })
			end

			openMomentCommentReport({
				commentId = commentId,
				channelId = channelId,
				reportedUserId = reportedUserId
			})
		end
	end, { openMomentCommentReport, channelId, v16 })
	local openBlockUser = v17.openBlockUser
	local onBlockCommentAuthor = React.useMemo(function()
		if openBlockUser == nil then
			return nil
		end

		return function(p: string, userId: string)
			openBlockUser({
				userId = userId,
				onBlockConfirmed = function()
					if FFlagMomentsCommentActionsRealtime and v16 ~= nil then
						v16.logRealtimeEvent("MomentsCommentAuthorBlock", { status = "attempted" })
					end

					commentsListCoordinator.hideCommentsByAuthor(data.feedItemId, userId)
				end,
				onBlockFailed = function()
					if FFlagMomentsCommentActionsRealtime and v16 ~= nil then
						v16.logRealtimeEvent("MomentsCommentAuthorBlock", { status = "failed" })
					end

					commentsListCoordinator.restoreCommentsByAuthor(data.feedItemId, userId)
				end,
				onBlockSucceeded = FFlagMomentsCommentActionsRealtime and v16 ~= nil and function()
					v16.logRealtimeEvent("MomentsCommentAuthorBlock", { status = "succeeded" })
				end or nil,
				openReportUser = onReportComment ~= nil and function()
					onReportComment(p, userId)
				end or nil
			})
		end
	end, { openBlockUser, onReportComment, commentsListCoordinator, data.feedItemId, v16 })
	local onDeleteComment = React.useCallback(function(commentId: string)
		local fn = FFlagMomentsComments and v16 ~= nil and function()
			v16.logEvent(EventNames.MomentCommentDeleted, { commentId = commentId })
		end or nil

		local function onDeleteFailed()
			showDeleteFailedToast(deleteFailed) -- inferred equivalent call
		end
		return commentsListCoordinator.deleteComment(data.feedItemId, commentId, onDeleteFailed, fn)
	end, { commentsListCoordinator, data.feedItemId, v16, deleteFailed })

	local ref3 = React.useRef(nil)
	local ref4

	if FFlagMomentsCommentsScrollToPostedComment then
		ref4 = React.useRef(nil)

		local pendingSubmission = v3.pendingSubmission
		local clientRequestId

		if pendingSubmission == nil then
			clientRequestId = nil
		else
			clientRequestId = pendingSubmission.clientRequestId
		end

		local ref5 = React.useRef(clientRequestId)
		React.useEffect(function()
			if clientRequestId == nil or clientRequestId == ref5.current then
				return
			end

			ref5.current = clientRequestId
			local current = ref4.current

			if current ~= nil then
				current.scrollToOffset(0)
			end
		end, { clientRequestId })
	else
		ref4 = nil
	end

	local shift_300 = v11.Color.Shift.Shift_300
	local creatorEnabled

	if v9 == nil then
		creatorEnabled = false
	else
		creatorEnabled = v9.creatorEnabled
	end

	local viewerCanWrite

	if v9 == nil then
		viewerCanWrite = false
	else
		viewerCanWrite = v9.viewerCanWrite
	end

	local row = React.useMemo(function()
		return {
			viewerUsername = viewerUsername,
			feedItemId = data.feedItemId,
			thumbsUpEmoteId = thumbsUpEmoteId,
			creatorEnabled = creatorEnabled,
			viewerCanWrite = viewerCanWrite,
			avatarBackgroundStyle = shift_300,
			scrollingFrameRef = ref3,
			onToggleReaction = onToggleReaction,
			onAddReaction = onAddReaction,
			onReportComment = onReportComment,
			onBlockCommentAuthor = onBlockCommentAuthor,
			onDeleteComment = onDeleteComment,
			onToggleCommentExpanded = v4.toggle,
			onToggleCommentTranslation = onToggleCommentTranslation,
			onRetryPendingSubmission = onRetryPendingSubmission,
			onEditPendingSubmission = onEditPendingSubmission,
			onRetryLoadMore = onRetryLoadMore
		}
	end, {
		viewerUsername,
		data.feedItemId,
		thumbsUpEmoteId,
		creatorEnabled,
		viewerCanWrite,
		shift_300,
		onToggleReaction,
		onAddReaction,
		onReportComment,
		onBlockCommentAuthor,
		onDeleteComment,
		v4,
		onToggleCommentTranslation or false,
		onRetryPendingSubmission,
		onEditPendingSubmission,
		onRetryLoadMore
	})
	local isScrollingEnabled

	if not FFlagMomentsCommentsAttachSheetScroller then
		local commentsSheetStore = getCommentsSheetStore(false)
		isScrollingEnabled = SignalsReact.useSignalBinding(commentsSheetStore.getIsListScrollingEnabled)
	end

	local v18 = {
		data = v12,
		layout = layout,
		rowBleed = small,
		row = row,
		scrollingFrame = 0,
		listScrollingFrameRef = 0,
		listRef = 0,
		isScrollingEnabled = 0,
		onEndReached = 0,
		onViewportChanged = 0,
		onContentLengthChanged = 0,
		onVisibleRangeChanged = 0,
		onVisibleItemsPresented = 0
	}
	local scrollingFrame

	if FFlagMomentsCommentsAttachSheetScroller then
		scrollingFrame = data.scrollingFrame
	end

	v18.scrollingFrame = scrollingFrame
	v18.listScrollingFrameRef = ref3
	v18.listRef = ref4
	v18.isScrollingEnabled = isScrollingEnabled

	if not v3.hasMore then
		onEndReached = nil
	end

	v18.onEndReached = onEndReached
	v18.onViewportChanged = onViewportChanged
	v18.onContentLengthChanged = onContentLengthChanged
	local onVisibleRangeChanged

	if v13 ~= nil then
		onVisibleRangeChanged = v13.onVisibleRangeChanged
	end

	v18.onVisibleRangeChanged = onVisibleRangeChanged
	v18.onVisibleItemsPresented = onVisibleItemsPresented
	return v18
end

return useCommentsListViewModel
