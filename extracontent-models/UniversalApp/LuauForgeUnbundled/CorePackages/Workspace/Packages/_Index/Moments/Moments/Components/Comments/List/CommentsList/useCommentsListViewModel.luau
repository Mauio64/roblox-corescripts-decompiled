local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Foundation")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Localization")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SignalsReact")
local ViewRecyclerReact = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/ViewRecyclerReact")
local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/MomentsCommon")
local fFlagMomentsComments = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SharedFlags").FFlagMomentsComments
local FFlagMomentsCommentActionsRealtime = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsCommentActionsRealtime")
local FFlagMomentsCommentTranslation = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsCommentTranslation")
local FFlagMomentsCommentTranslationShownByDefault = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsCommentTranslationShownByDefault")
local FFlagMomentsCommentsRevealAfterMeasure = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsCommentsRevealAfterMeasure")
local FFlagMomentsCommentsScrollToPostedComment = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsCommentsScrollToPostedComment")
local FFlagMomentsCommentsAttachSheetScroller = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsCommentsAttachSheetScroller")
local eventNames = MomentsCommon.Analytics.EventNames

local MomentsGetMomentsCommentsStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/DataHydration/MomentsGetMomentsCommentsStore")
local MomentsGetMomentsReactionsStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/DataHydration/MomentsGetMomentsReactionsStore")
local MomentsResolveEmoteId = require("@game/CorePackages/Workspace/Packages/_Index/Moments/DataHydration/MomentsResolveEmoteId")
require("@game/CorePackages/Workspace/Packages/_Index/Moments/MomentsTypes")
local GetCommentCollectionStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/GetCommentCollectionStore")
local CommentCollectionTypes = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/GetCommentCollectionStore/CommentCollectionTypes")
local getCommentsListCoordinator = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/List/getCommentsListCoordinator")
local getCommentsSheetStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/Sheet/getCommentsSheetStore")
local useCommentCapabilities = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/useCommentCapabilities")
local GetToastStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetToastStore")
local useMomentsHost = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/MomentsHostContext").useMomentsHost
local ReactionType = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Enums/ReactionType")
local buildCommentRows = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/List/Rows/buildCommentRows")
require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/List/Rows/CommentRowTypes")
local CommentsListItems = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/List/CommentsList/CommentsListItems")
require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/List/CommentsList/CommentsListRowContext")
require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/List/CommentsList/CommentsListView")
local createExpandedCommentsStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/List/CommentsList/createExpandedCommentsStore")
local createToggledTranslationsStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/List/CommentsList/createToggledTranslationsStore")
local useCommentsListReveal = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/List/CommentsList/useCommentsListReveal")

local Players = game:GetService("Players")

local loadStatus = CommentCollectionTypes.LoadStatus
local useLocalization = Localization.Hooks.useLocalization

local v5 = { deleteFailed = "Feature.Moments.Label.CommentDeleteFailed" }

local function showDeleteFailedToast(p2)
	GetToastStore(false).triggerToast({ title = p2, text = "" })
end

local function useCommentsListViewModel(data)
	local deleteFailed = useLocalization(v5).deleteFailed
	local localPlayer = Players.LocalPlayer
	local v6 = localPlayer == nil and "" or localPlayer.Name
	local v7 = GetCommentCollectionStore(false)
	local v8 = React.useMemo(function()
		return v7.getState(data.feedItemId)
	end, { v7, data.feedItemId })
	local v9 = SignalsReact.useSignalState(v8)

	local v10 = React.useState(createExpandedCommentsStore)
	local getExpandedCommentIds = v10.getExpandedCommentIds

	local v11 = if FFlagMomentsCommentTranslation then React.useState(createToggledTranslationsStore) else nil

	local getToggledCommentIds = if v11 ~= nil then v11.getToggledCommentIds else nil
	local v12 = React.useMemo(function()
		local v13 = nil
		return Signals.createComputed(function(p2)
			local v15 = buildCommentRows({
				state = v8(p2),
				resolveComment = function(p3)
					return MomentsGetMomentsCommentsStore(false).getCachedComment(p3).data(p2)
				end,
				previousRows = v13,
				expandedCommentIds = getExpandedCommentIds(p2),
				translation = getToggledCommentIds ~= nil and {
					showsTranslationByDefault = FFlagMomentsCommentTranslationShownByDefault,
					toggledCommentIds = getToggledCommentIds(p2)
				} or nil
			})

			v13 = v15
			return v15
		end)
	end, { v8, getExpandedCommentIds, getToggledCommentIds or false })
	local v13 = SignalsReact.useSignalState(v12)
	local v14 = MomentsGetMomentsCommentsStore(false)
	local v15 = React.useMemo(function()
		return v14.getCachedMomentComments(data.feedItemId)
	end, { v14, data.feedItemId })
	local v16 = SignalsReact.useSignalState(v15.data)

	local v17 = MomentsGetMomentsReactionsStore(false)
	local v18 = React.useMemo(function()
		return Signals.createComputed(function(p2)
			local getCachedEmojiCatalog = v17.getCachedEmojiCatalog

			if getCachedEmojiCatalog == nil then
				return nil
			end

			local cachedEmojiCatalog = getCachedEmojiCatalog(p2)

			if cachedEmojiCatalog.source == "cache" and cachedEmojiCatalog.status == "Ready" then
				return MomentsResolveEmoteId.resolveOptionalEmoteIdForReaction(
					cachedEmojiCatalog.emojis,
					ReactionType.ThumbsUp
				)
			end

			return nil
		end)
	end, { v17 })
	local v19 = SignalsReact.useSignalState(v18)

	if not useCommentCapabilities().canReact then
		v19 = nil
	end

	local v20 = Foundation.Hooks.useTokens()

	local small = v20.Padding.Small

	local size_2000 = v20.Size.Size_2000
	local v21 = React.useState(function()
		return ViewRecyclerReact.Layout.measured({ estimatedItemLength = size_2000 })
	end)

	React.useEffect(function()
		return function()
			v21.destroy()
		end
	end, { v21 })

	local loadMoreStatus = v9.loadMoreStatus
	local isReadOnly = data.isReadOnly
	local v22 = React.useMemo(function()
		local result = table.create(#v13 + 2)

		for k, v23 in v13 do
			result[k] = v23
		end

		if loadMoreStatus == loadStatus.Loading or loadMoreStatus == loadStatus.Failed then
			table.insert(result, CommentsListItems.loadMore(loadMoreStatus))
		end

		if isReadOnly then
			table.insert(result, CommentsListItems.readOnlyNotice())
		end

		return result
	end, { v13, loadMoreStatus, isReadOnly })
	local v23 = React.useMemo(function()
		return { items = v22, getItemKey = CommentsListItems.getItemKey }
	end, { v22 })

	local v24 = nil
	local v25 = nil

	if FFlagMomentsCommentsRevealAfterMeasure and FFlagMomentsCommentsAttachSheetScroller then
		local ref = React.useRef(data.onRevealed)
		ref.current = data.onRevealed
		v25 = React.useCallback(function()
			local current = ref.current

			if current ~= nil then
				current()
			end
		end, {})

		React.useEffect(function()
			local thread = task.delay(1, v25)
			return function()
				pcall(task.cancel, thread)
			end
		end, { v25 })
	elseif FFlagMomentsCommentsRevealAfterMeasure then
		v24 = useCommentsListReveal(v21, v22, data.onRevealed)
	end

	local v26 = getCommentsListCoordinator(false)
	local v27 = React.useCallback(function()
		return v26.loadMore(data.feedItemId, data.sessionId)
	end, { v26, data.feedItemId, data.sessionId })
	local v28 = React.useCallback(function()
		v27()
	end, { v27 })

	local ref = React.useRef(0)
	local ref2 = React.useRef(0)
	local v29 = React.useCallback(function()
		if ref.current > 0 and ref2.current > 0 and ref2.current <= ref.current then
			v27()
		end
	end, { v27 })
	local v30 = React.useCallback(function(p2)
		ref.current = p2.Y
		v29()
	end, { v29 })
	local v31 = React.useCallback(function(current)
		ref2.current = current
		v29()
	end, { v29 })

	local v32 = React.useCallback(function()
		v26.retryLoadMore(data.feedItemId, data.sessionId)
	end, { v26, data.feedItemId, data.sessionId })
	local v33 = React.useCallback(function()
		v26.retryPendingSubmission(data.feedItemId, data.sessionId)
	end, { v26, data.feedItemId, data.sessionId })
	local v34 = React.useCallback(function()
		v26.editPendingSubmission(data.feedItemId, data.sessionId)
	end, { v26, data.feedItemId, data.sessionId })
	local v35

	if fFlagMomentsComments then
		v35 = getCommentsSheetStore(false).getAnalyticsSession(data.feedItemId, data.sessionId)
	else
		v35 = nil
	end

	local v36 = React.useCallback(function(p2, p3, p4, p5)
		if fFlagMomentsComments and v35 ~= nil then
			v35.logEvent(eventNames.MomentCommentReactButtonClicked, {
				commentId = p2,
				reactionSelected = tostring(not p5)
			})
		end

		if p5 then
			return v26.ensureReactionAbsent(data.feedItemId, p2, p3, p4)
		end

		return v26.ensureReactionPresent(data.feedItemId, p2, p3, p4)
	end, { v26, data.feedItemId, v35 })

	local v37 = React.useCallback(function(p2, p3, p4)
		return v26.ensureReactionPresent(data.feedItemId, p2, p3, p4)
	end, { v26, data.feedItemId })

	local v38 = useMomentsHost()
	local openMomentCommentReport = v38.openMomentCommentReport
	local channelId = v9.channelId
	local v39 = React.useMemo(function()
		if openMomentCommentReport == nil or channelId == nil then
			return nil
		end

		return function(p2, p3)
			if fFlagMomentsComments and v35 ~= nil then
				v35.logEvent(eventNames.MomentCommentReportClicked, { commentId = p2 })
			end

			if FFlagMomentsCommentActionsRealtime and v35 ~= nil then
				v35.logRealtimeEvent("MomentsCommentReport", { status = "clicked" })
			end

			openMomentCommentReport({
				commentId = p2,
				channelId = channelId,
				reportedUserId = p3
			})
		end
	end, { openMomentCommentReport, channelId, v35 })
	local openBlockUser = v38.openBlockUser
	local v40 = React.useMemo(function()
		if openBlockUser == nil then
			return nil
		end

		return function(p2, p3)
			openBlockUser({
				userId = p3,
				onBlockConfirmed = function()
					if FFlagMomentsCommentActionsRealtime and v35 ~= nil then
						v35.logRealtimeEvent("MomentsCommentAuthorBlock", {
							status = "attempted"
						})
					end

					v26.hideCommentsByAuthor(data.feedItemId, p3)
				end,
				onBlockFailed = function()
					if FFlagMomentsCommentActionsRealtime and v35 ~= nil then
						v35.logRealtimeEvent("MomentsCommentAuthorBlock", {
							status = "failed"
						})
					end

					v26.restoreCommentsByAuthor(data.feedItemId, p3)
				end,
				onBlockSucceeded = FFlagMomentsCommentActionsRealtime and v35 ~= nil and function()
					v35.logRealtimeEvent("MomentsCommentAuthorBlock", {
						status = "succeeded"
					})
				end or nil,
				openReportUser = v39 ~= nil and function()
					v39(p2, p3)
				end or nil
			})
		end
	end, { openBlockUser, v39, v26, data.feedItemId, v35 })
	local v41 = React.useCallback(function(p2)
		local fn = fFlagMomentsComments and v35 ~= nil and function()
			v35.logEvent(eventNames.MomentCommentDeleted, { commentId = p2 })
		end or nil

		local function onDeleteFailed()
			GetToastStore(false).triggerToast({ title = deleteFailed, text = "" })
		end
		return v26.deleteComment(data.feedItemId, p2, onDeleteFailed, fn)
	end, { v26, data.feedItemId, v35, deleteFailed })

	local ref3 = React.useRef(nil)
	local ref4

	if FFlagMomentsCommentsScrollToPostedComment then
		ref4 = React.useRef(nil)

		local pendingSubmission = v9.pendingSubmission
		local clientRequestId = if pendingSubmission ~= nil then pendingSubmission.clientRequestId else nil

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

	local shift_300 = v20.Color.Shift.Shift_300
	local v42 = not (v16 == nil) and v16.creatorEnabled
	local v43 = not (v16 == nil) and v16.viewerCanWrite
	local v44 = React.useMemo(function()
		local v45 = {
			viewerUsername = v6,
			feedItemId = data.feedItemId,
			thumbsUpEmoteId = v19,
			creatorEnabled = v42,
			viewerCanWrite = v43,
			avatarBackgroundStyle = shift_300,
			scrollingFrameRef = ref3,
			onToggleReaction = v36,
			onAddReaction = v37,
			onReportComment = v39,
			onBlockCommentAuthor = v40,
			onDeleteComment = v41,
			onToggleCommentExpanded = v10.toggle,
			onToggleCommentTranslation = 0,
			onRetryPendingSubmission = 0,
			onEditPendingSubmission = 0,
			onRetryLoadMore = 0
		}
		local v46 = if v11 ~= nil then v11.toggle else nil
		v45.onToggleCommentTranslation = v46
		v45.onRetryPendingSubmission = v33
		v45.onEditPendingSubmission = v34
		v45.onRetryLoadMore = v32
		return v45
	end, {
		v6,
		data.feedItemId,
		v19,
		v42,
		v43,
		shift_300,
		v36,
		v37,
		v39,
		v40,
		v41,
		v10,
		v11 or false,
		v33,
		v34,
		v32
	})
	local v45

	if not FFlagMomentsCommentsAttachSheetScroller then
		local v46 = getCommentsSheetStore(false)
		v45 = SignalsReact.useSignalBinding(v46.getIsListScrollingEnabled)
	end

	local v46 = {
		data = v23,
		layout = v21,
		rowBleed = small,
		row = v44,
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

	local v47 = if FFlagMomentsCommentsAttachSheetScroller then data.scrollingFrame else nil
	v46.scrollingFrame = v47
	v46.listScrollingFrameRef = ref3
	v46.listRef = ref4
	v46.isScrollingEnabled = v45

	if not v9.hasMore then
		v28 = nil
	end

	v46.onEndReached = v28
	v46.onViewportChanged = v30
	v46.onContentLengthChanged = v31
	local v48 = if v24 ~= nil then v24.onVisibleRangeChanged else nil
	v46.onVisibleRangeChanged = v48
	v46.onVisibleItemsPresented = v25
	return v46
end

return useCommentsListViewModel
