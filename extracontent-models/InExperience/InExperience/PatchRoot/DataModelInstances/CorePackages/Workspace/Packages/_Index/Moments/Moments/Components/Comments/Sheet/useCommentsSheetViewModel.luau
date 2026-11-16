local LocalizationService = game:GetService("LocalizationService")
local UserInputService = game:GetService("UserInputService")

local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)
local MomentsGetMomentsCommentsStore = require(parent.DataHydration.MomentsGetMomentsCommentsStore)

require(Moments.Components.Comments.Composer.CommentsComposerContainer)

require(Moments.Components.Comments.Panel.CommentsPanelBody.CommentsPanelBodyContainer)
local GetCommentCollectionStore = require(Moments.Components.Comments.GetCommentCollectionStore)
local getCommentsPanelState = require(Moments.Components.Comments.Panel.getCommentsPanelState)
require(Moments.Components.SheetShim)
local useCommentCapabilities = require(Moments.Components.Comments.useCommentCapabilities)
local FFlagMomentsCommentsAttachSheetScroller = require(Moments.Flags.FFlagMomentsCommentsAttachSheetScroller)
require(script.Parent.CommentsSheetView)
local getCommentsSheetStore = require(script.Parent.getCommentsSheetStore)
local getCommentsVideoLift = require(script.Parent.getCommentsVideoLift)
local useSheetContentScrollingFrame = require(script.Parent.useSheetContentScrollingFrame)

local useLocalization = Localization.Hooks.useLocalization

local function useCommentsSheetViewModel()
	local commentsSheetStore = getCommentsSheetStore(false)
	local isOpen = SignalsReact.useSignalState(commentsSheetStore.getIsOpen)
	local feedItemId = SignalsReact.useSignalState(commentsSheetStore.getFeedItemId)
	local sessionId = SignalsReact.useSignalState(commentsSheetStore.getOpenSessionId)
	local momentsGetMomentsCommentsStore = MomentsGetMomentsCommentsStore(false)
	local v = React.useMemo(function()
		return momentsGetMomentsCommentsStore.getCachedMomentComments(feedItemId or "")
	end, { momentsGetMomentsCommentsStore, feedItemId })
	local comments = SignalsReact.useSignalState(v.data)
	local v2 = useCommentCapabilities()

	local close = commentsSheetStore.close
	React.useEffect(function()
		if isOpen and not v2.canRead then
			close()
		end
	end, { isOpen, v2.canRead, close })
	local ref = React.useRef(nil)
	local state, setState = React.useState(nil)
	local commentCollectionStore = GetCommentCollectionStore(false)
	local v3 = feedItemId or ""
	local v4 = React.useMemo(function()
		return commentCollectionStore.getState(v3)
	end, { commentCollectionStore, v3 })
	local v5 = SignalsReact.useSignalState(v4)
	local v6 = v5.pendingSubmission == nil and 0 or 1
	local v7

	if v5.initialLoadStatus == "Success" and not v5.hasMore then
		v7 = math.max(0, #v5.orderedCommentIds - v6)
	end

	if comments ~= nil and comments.count ~= nil then
		v7 = comments.count
	end

	local count

	if v7 ~= nil then
		count = Localization.abbreviateCount(v7, LocalizationService.RobloxLocaleId)
	end

	local commentsPanelState = getCommentsPanelState(comments, v5)
	local isListDisplayed

	if commentsPanelState.contentState == "list" then
		isListDisplayed = feedItemId ~= nil
	else
		isListDisplayed = false
	end

	local scrollingFrame, onScrollingFrameChanged

	if FFlagMomentsCommentsAttachSheetScroller then
		scrollingFrame, onScrollingFrameChanged = useSheetContentScrollingFrame(isListDisplayed)
	end

	local title = useLocalization({
		title = (v7 == nil or not (v7 > 0) or count == nil) and "Feature.Moments.Title.Comments" or {
			(comments == nil or not comments.countIsCapped) and "Feature.Moments.Title.CommentsWithCount" or "Feature.Moments.Title.CommentsWithCappedCount",
			count = count
		}
	}).title
	local v8

	if isOpen then
		if feedItemId == nil or feedItemId == "" then
			v8 = false
		else
			v8 = v2.canRead and v2.canWrite and commentsPanelState.canCompose
		end
	else
		v8 = isOpen
	end

	local setSnapPointIndex = commentsSheetStore.setSnapPointIndex
	local onSnapPointChanged = React.useCallback(function(_: number, p: number)
		setSnapPointIndex(p)
	end, { setSnapPointIndex })

	local v9 = Foundation.Hooks.useOverlay()
	local getVideoLift = commentsSheetStore.getVideoLift
	local setVideoLift = commentsSheetStore.setVideoLift
	local onContentInsetChanged = React.useCallback(function(p)
		if v9 == nil then
			setVideoLift(nil)
		else
			setVideoLift(getCommentsVideoLift(
				{
					sheetInset = p.bottom,
					overlayTop = v9.AbsolutePosition.Y,
					overlayHeight = v9.AbsoluteSize.Y,
					isKeyboardVisible = UserInputService.OnScreenKeyboardVisible
				},
				getVideoLift(false)
			))
		end
	end, { v9, getVideoLift, setVideoLift })

	React.useEffect(function()
		return function()
			setVideoLift(nil)
		end
	end, { setVideoLift })

	return {
		isOpen = isOpen,
		title = title,
		onClose = commentsSheetStore.close,
		onSnapPointChanged = onSnapPointChanged,
		onContentInsetChanged = onContentInsetChanged,
		isListDisplayed = isListDisplayed,
		scrollingFrameRef = ref,
		onScrollingFrameChanged = onScrollingFrameChanged,
		actionsRef = setState,
		panelBodyProps = {
			isOpen = isOpen,
			feedItemId = feedItemId,
			comments = comments,
			panelState = commentsPanelState,
			sessionId = sessionId,
			scrollingFrameRef = ref,
			scrollingFrame = scrollingFrame,
			actionsFrame = state,
			onClose = commentsSheetStore.close
		},
		composerProps = v8 and { feedItemId = feedItemId, sessionId = sessionId } or nil
	}
end

return useCommentsSheetViewModel
