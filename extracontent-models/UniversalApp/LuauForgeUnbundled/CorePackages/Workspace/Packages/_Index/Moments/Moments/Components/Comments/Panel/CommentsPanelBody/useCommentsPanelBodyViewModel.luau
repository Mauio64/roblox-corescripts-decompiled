require("@game/CorePackages/Workspace/Packages/_Index/Moments/MomentsTypes")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SignalsReact")

local FFlagMomentsCommentsRevealAfterMeasure = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsCommentsRevealAfterMeasure")
local FFlagMomentsCommentsAttachSheetScroller = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsCommentsAttachSheetScroller")
local GetCommentCollectionStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/GetCommentCollectionStore")
local getCommentsListCoordinator = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/List/getCommentsListCoordinator")
require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/Panel/getCommentsPanelState")
require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/Panel/CommentsPanelBody/CommentsPanelBodyView")
local useVisibleContentHeight = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/Panel/CommentsPanelBody/useVisibleContentHeight")

local function useCommentsPanelBodyViewModel(data)
	local feedItemId = data.feedItemId
	local v5 = React.useMemo(function()
		if data.isOpen and feedItemId ~= nil and feedItemId ~= "" then
			return { feedItemId = feedItemId, sessionId = data.sessionId }
		end

		return nil
	end, { data.isOpen, data.sessionId, feedItemId })
	local state, setState = React.useState(nil)
	local v6 = GetCommentCollectionStore(false)
	local v7 = feedItemId or ""
	local v8 = React.useMemo(function()
		return v6.getState(v7)
	end, { v6, v7 })
	local v9 = SignalsReact.useSignalState(v8)
	local v10 = getCommentsListCoordinator(false)

	React.useEffect(function()
		if v5 == nil then
			return
		end

		local session = v10.acquireSession(v5.feedItemId, v5.sessionId)
		setState(v5)
		return session
	end, { v10, v5 })

	local comments = data.comments
	local v11 = comments == nil or comments.viewerCanRead
	local pendingSubmission = v9.pendingSubmission
	local v12 = pendingSubmission == nil and "" or pendingSubmission.clientRequestId
	local v13 = pendingSubmission == nil and "" or pendingSubmission.status
	React.useEffect(function()
		if v5 ~= nil and state == v5 and v11 then
			v10.ensureInitialLoad(v5.feedItemId, v5.sessionId)
		end
	end, { state, v10, v5, v11, v9.initialLoadStatus, v9.loadMoreStatus, v12, v13 })

	local panelState = data.panelState
	React.useEffect(function()
		if v5 ~= nil and state == v5 and panelState.shouldClose then
			data.onClose()
		end
	end, { state, data.onClose, panelState.shouldClose, v5 })

	local v14 = React.useCallback(function()
		if feedItemId ~= nil and feedItemId ~= "" then
			v10.retryInitial(feedItemId, data.sessionId)
		end
	end, { v10, data.sessionId, feedItemId })

	local v15 = useVisibleContentHeight(data.scrollingFrameRef, data.actionsFrame)

	local v16 = nil
	local v17, v18

	if FFlagMomentsCommentsRevealAfterMeasure then
		local formatted = `{feedItemId or ""}:{data.sessionId}`
		local state2, setState2 = React.useState(nil)
		v17 = state2 == formatted
		local v19

		if FFlagMomentsCommentsAttachSheetScroller then
			local v20
			v16, v20 = React.useBinding(true)
			v19 = v20
			React.useLayoutEffect(function()
				if not v17 then
					v19(true)
				end
			end, { v17 })
		else
			v19 = nil
		end

		v18 = React.useCallback(function()
			if v19 ~= nil then
				v19(false)
			end

			setState2(formatted)
		end, { formatted })

		local v20 = panelState.contentState == "list" and feedItemId ~= nil
		React.useEffect(function()
			if not v20 then
				setState2(nil)
			end
		end, { v20 })
	else
		v17 = true
	end

	local v19 = {
		contentState = panelState.contentState,
		isReadOnly = panelState.isReadOnly,
		canRetryInitial = panelState.canRetryInitial,
		feedItemId = feedItemId,
		sessionId = data.sessionId,
		stateMinHeight = v15,
		onRetryInitial = v14,
		isListRevealed = v17,
		onListRevealed = v18,
		scrollingFrame = 0,
		revealPlaceholdersVisible = 0
	}

	local v20 = if FFlagMomentsCommentsAttachSheetScroller then data.scrollingFrame else nil
	v19.scrollingFrame = v20
	v19.revealPlaceholdersVisible = v16
	return v19
end

return useCommentsPanelBodyViewModel
