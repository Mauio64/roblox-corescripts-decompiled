local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

require(parent.MomentsTypes)
local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)

local FFlagMomentsCommentsRevealAfterMeasure = require(Moments.Flags.FFlagMomentsCommentsRevealAfterMeasure)
local FFlagMomentsCommentsAttachSheetScroller = require(Moments.Flags.FFlagMomentsCommentsAttachSheetScroller)
local GetCommentCollectionStore = require(Moments.Components.Comments.GetCommentCollectionStore)
local getCommentsListCoordinator = require(Moments.Components.Comments.List.getCommentsListCoordinator)
require(script.Parent.Parent.getCommentsPanelState)
require(script.Parent.CommentsPanelBodyView)
local useVisibleContentHeight = require(script.Parent.useVisibleContentHeight)

local function useCommentsPanelBodyViewModel(data)
	local feedItemId = data.feedItemId
	local v = React.useMemo(function()
		if data.isOpen and feedItemId ~= nil and feedItemId ~= "" then
			return { feedItemId = feedItemId, sessionId = data.sessionId }
		end

		return nil
	end, { data.isOpen, data.sessionId, feedItemId })
	local state, setState = React.useState(nil)
	local commentCollectionStore = GetCommentCollectionStore(false)
	local v2 = feedItemId or ""
	local v3 = React.useMemo(function()
		return commentCollectionStore.getState(v2)
	end, { commentCollectionStore, v2 })
	local v4 = SignalsReact.useSignalState(v3)
	local commentsListCoordinator = getCommentsListCoordinator(false)

	React.useEffect(function()
		if v == nil then
			return
		end

		local session = commentsListCoordinator.acquireSession(v.feedItemId, v.sessionId)
		setState(v)
		return session
	end, { commentsListCoordinator, v })

	local comments = data.comments
	local v5 = comments == nil or comments.viewerCanRead
	local pendingSubmission = v4.pendingSubmission
	local v6 = pendingSubmission == nil and "" or pendingSubmission.clientRequestId
	local v7 = pendingSubmission == nil and "" or pendingSubmission.status
	React.useEffect(function()
		if v ~= nil and state == v and v5 then
			commentsListCoordinator.ensureInitialLoad(v.feedItemId, v.sessionId)
		end
	end, { state, commentsListCoordinator, v, v5, v4.initialLoadStatus, v4.loadMoreStatus, v6, v7 })

	local panelState = data.panelState
	React.useEffect(function()
		if v ~= nil and state == v and panelState.shouldClose then
			data.onClose()
		end
	end, { state, data.onClose, panelState.shouldClose, v })

	local onRetryInitial = React.useCallback(function()
		if feedItemId ~= nil and feedItemId ~= "" then
			commentsListCoordinator.retryInitial(feedItemId, data.sessionId)
		end
	end, { commentsListCoordinator, data.sessionId, feedItemId })

	local stateMinHeight = useVisibleContentHeight(data.scrollingFrameRef, data.actionsFrame)

	local revealPlaceholdersVisible = nil
	local isListRevealed, onListRevealed

	if FFlagMomentsCommentsRevealAfterMeasure then
		local formatted = `{feedItemId or ""}:{data.sessionId}`
		local state2, setState2 = React.useState(nil)
		isListRevealed = state2 == formatted
		local v8

		if FFlagMomentsCommentsAttachSheetScroller then
			local v9
			revealPlaceholdersVisible, v9 = React.useBinding(true)
			v8 = v9
			React.useLayoutEffect(function()
				if not isListRevealed then
					v8(true)
				end
			end, { isListRevealed })
		else
			v8 = nil
		end

		onListRevealed = React.useCallback(function()
			if v8 ~= nil then
				v8(false)
			end

			setState2(formatted)
		end, { formatted })
		local v9

		if panelState.contentState == "list" then
			v9 = feedItemId ~= nil
		else
			v9 = false
		end

		React.useEffect(function()
			if not v9 then
				setState2(nil)
			end
		end, { v9 })
	else
		isListRevealed = true
	end

	local v8 = {
		contentState = panelState.contentState,
		isReadOnly = panelState.isReadOnly,
		canRetryInitial = panelState.canRetryInitial,
		feedItemId = feedItemId,
		sessionId = data.sessionId,
		stateMinHeight = stateMinHeight,
		onRetryInitial = onRetryInitial,
		isListRevealed = isListRevealed,
		onListRevealed = onListRevealed,
		scrollingFrame = 0,
		revealPlaceholdersVisible = 0
	}
	local scrollingFrame

	if FFlagMomentsCommentsAttachSheetScroller then
		scrollingFrame = data.scrollingFrame
	end

	v8.scrollingFrame = scrollingFrame
	v8.revealPlaceholdersVisible = revealPlaceholdersVisible
	return v8
end

return useCommentsPanelBodyViewModel
