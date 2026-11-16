local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)
local ViewRecycler = require(parent.ViewRecycler)

local CommentsListFooterView = require(script.Parent.Parent.CommentsListFooterView)
local CommentsListRowContext = require(script.Parent.CommentsListRowContext)
local CommentRowContainer = require(script.Parent.Parent.Rows.CommentRow.CommentRowContainer)
require(script.Parent.Parent.Rows.CommentRowTypes)
local CommentsReadOnlyNoticeView = require(Moments.Components.Comments.Panel.CommentsReadOnlyNoticeView)
local PendingCommentRowView = require(script.Parent.Parent.Rows.PendingCommentRowView)
require(Moments.Components.Comments.GetCommentCollectionStore.CommentCollectionTypes)
local FFlagMomentsCommentsAttachSheetScroller = require(Moments.Flags.FFlagMomentsCommentsAttachSheetScroller)

local useCommentsListRow = CommentsListRowContext.useCommentsListRow
local tag = FFlagMomentsCommentsAttachSheetScroller and "size-full-0 auto-y padding-x-medium"
	or "size-full-0 auto-y padding-x-small"
local tag2 = FFlagMomentsCommentsAttachSheetScroller and "size-full-0 auto-y padding-x-xlarge"
	or "size-full-0 auto-y padding-x-large"
local v = { readiness = ViewRecycler.RecyclableViewReadiness.ReadyOnCommit }

local function CommentItemView(p)
	local v2 = SignalsReact.useSignalState(p.itemSignal)
	local v3 = useCommentsListRow()

	if v2.type == "comment" then
		return React.createElement(Foundation.View, { tag = tag }, {
			Row = React.createElement(CommentRowContainer, {
				feedItemId = v3.feedItemId,
				commentId = v2.commentId,
				text = v2.text,
				createdAt = v2.createdAt,
				viewerUsername = v3.viewerUsername,
				thumbsUpEmoteId = v3.thumbsUpEmoteId,
				creatorEnabled = v3.creatorEnabled,
				viewerCanWrite = v3.viewerCanWrite,
				scrollingFrameRef = v3.scrollingFrameRef,
				avatarBackgroundStyle = v3.avatarBackgroundStyle,
				onToggleReaction = v3.onToggleReaction,
				onAddReaction = v3.onAddReaction,
				onReportComment = v3.onReportComment,
				onBlockCommentAuthor = v3.onBlockCommentAuthor,
				onDeleteComment = v3.onDeleteComment,
				isExpanded = v2.isExpanded,
				onToggleExpanded = v3.onToggleCommentExpanded,
				translationState = v2.translationState,
				onToggleTranslation = v3.onToggleCommentTranslation
			})
		})
	end

	return nil
end

local function PendingItemView(p)
	local v2 = SignalsReact.useSignalState(p.itemSignal)
	local v3 = useCommentsListRow()

	if v2.type ~= "pending" then
		return nil
	end

	local v4 = v2.status == "OutcomeUnknown"
	local createElement = React.createElement
	local view = Foundation.View

	local createElement2 = React.createElement
	local v5 = {
		rowKey = v2.key,
		text = v2.text,
		viewerUsername = v3.viewerUsername,
		avatarBackgroundStyle = v3.avatarBackgroundStyle,
		status = v2.status,
		onRetry = 0,
		onEdit = 0
	}
	local onRetry

	if v4 then
		onRetry = v3.onRetryPendingSubmission
	end

	v5.onRetry = onRetry
	local onEdit

	if v4 then
		onEdit = v3.onEditPendingSubmission
	end

	v5.onEdit = onEdit
	return createElement(view, { tag = tag }, {
		Row = createElement2(PendingCommentRowView, v5)
	})
end

local function LoadMoreItemView(p)
	local v2 = SignalsReact.useSignalState(p.itemSignal)
	local v3 = useCommentsListRow()

	if v2.type == "loadMore" then
		return React.createElement(Foundation.View, { tag = tag2 }, {
			Footer = React.createElement(CommentsListFooterView, {
				status = v2.status,
				onRetry = v3.onRetryLoadMore
			})
		})
	end

	return nil
end

local function ReadOnlyNoticeItemView(_)
	return React.createElement(Foundation.View, { tag = tag2 }, {
		Notice = React.createElement(CommentsReadOnlyNoticeView)
	})
end

local frozen = table.freeze({
	comment = ViewRecycler.createRecyclableView(CommentItemView, v),
	pending = ViewRecycler.createRecyclableView(PendingItemView, v),
	loadMore = ViewRecycler.createRecyclableView(LoadMoreItemView),
	readOnlyNotice = ViewRecycler.createRecyclableView(ReadOnlyNoticeItemView)
})

local v2 = {}
local onlyNotice = { type = "readOnlyNotice", key = "footer:read-only-notice" }

table.freeze(onlyNotice)
return table.freeze({
	getItemType = function(p, _: number)
		local itemType = frozen[p.type]
		assert(itemType ~= nil, `CommentsListItems: unknown item type "{tostring(p.type)}"`)
		return itemType
	end,
	getItemKey = function(p, _: number)
		return p.key
	end,
	loadMore = function(status)
		local v3 = v2[status]

		if v3 ~= nil then
			return v3
		end

		local v4 = { type = "loadMore", key = "footer:load-more", status = status }

		table.freeze(v4)
		v2[status] = v4
		return v4
	end,
	readOnlyNotice = function()
		return onlyNotice
	end
})
