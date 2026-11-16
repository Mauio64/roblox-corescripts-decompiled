local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SignalsReact")
local ViewRecyclerReact = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/ViewRecyclerReact")

local CommentsListFooterView = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/List/CommentsListFooterView")
local CommentsListRowContext = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/List/CommentsList/CommentsListRowContext")
local CommentRowContainer = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/List/Rows/CommentRow/CommentRowContainer")
require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/List/Rows/CommentRowTypes")
local CommentsReadOnlyNoticeView = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/Panel/CommentsReadOnlyNoticeView")
local PendingCommentRowView = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/List/Rows/PendingCommentRowView")
require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/GetCommentCollectionStore/CommentCollectionTypes")
local FFlagMomentsCommentsAttachSheetScroller = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsCommentsAttachSheetScroller")

local useCommentsListRow = CommentsListRowContext.useCommentsListRow
local v5 = FFlagMomentsCommentsAttachSheetScroller and "size-full-0 auto-y padding-x-medium" or "size-full-0 auto-y padding-x-small"
local v6 = FFlagMomentsCommentsAttachSheetScroller and "size-full-0 auto-y padding-x-xlarge" or "size-full-0 auto-y padding-x-large"
local v7 = { readiness = ViewRecyclerReact.RecyclableViewReadiness.ReadyOnCommit }

local function CommentItemView(p2)
	local v8 = SignalsReact.useSignalState(p2.itemSignal)
	local v9 = useCommentsListRow()

	if v8.type == "comment" then
		return React.createElement(Foundation.View, { tag = v5 }, {
			Row = React.createElement(CommentRowContainer, {
				feedItemId = v9.feedItemId,
				commentId = v8.commentId,
				text = v8.text,
				createdAt = v8.createdAt,
				viewerUsername = v9.viewerUsername,
				thumbsUpEmoteId = v9.thumbsUpEmoteId,
				creatorEnabled = v9.creatorEnabled,
				viewerCanWrite = v9.viewerCanWrite,
				scrollingFrameRef = v9.scrollingFrameRef,
				avatarBackgroundStyle = v9.avatarBackgroundStyle,
				onToggleReaction = v9.onToggleReaction,
				onAddReaction = v9.onAddReaction,
				onReportComment = v9.onReportComment,
				onBlockCommentAuthor = v9.onBlockCommentAuthor,
				onDeleteComment = v9.onDeleteComment,
				isExpanded = v8.isExpanded,
				onToggleExpanded = v9.onToggleCommentExpanded,
				translationState = v8.translationState,
				onToggleTranslation = v9.onToggleCommentTranslation
			})
		})
	end

	return nil
end

local function PendingItemView(p2)
	local v8 = SignalsReact.useSignalState(p2.itemSignal)
	local v9 = useCommentsListRow()

	if v8.type ~= "pending" then
		return nil
	end

	local v10 = v8.status == "OutcomeUnknown"
	local createElement = React.createElement
	local view = Foundation.View

	local createElement2 = React.createElement
	local v14 = {
		rowKey = v8.key,
		text = v8.text,
		viewerUsername = v9.viewerUsername,
		avatarBackgroundStyle = v9.avatarBackgroundStyle,
		status = v8.status,
		onRetry = 0,
		onEdit = 0
	}
	local v15 = if v10 then v9.onRetryPendingSubmission else nil
	v14.onRetry = v15
	local v16 = if v10 then v9.onEditPendingSubmission else nil
	v14.onEdit = v16
	return createElement(view, { tag = v5 }, { Row = createElement2(PendingCommentRowView, v14) })
end

local function LoadMoreItemView(p2)
	local v8 = SignalsReact.useSignalState(p2.itemSignal)
	local v9 = useCommentsListRow()

	if v8.type == "loadMore" then
		return React.createElement(Foundation.View, { tag = v6 }, {
			Footer = React.createElement(CommentsListFooterView, {
				status = v8.status,
				onRetry = v9.onRetryLoadMore
			})
		})
	end

	return nil
end

local function ReadOnlyNoticeItemView(p2)
	return React.createElement(Foundation.View, { tag = v6 }, {
		Notice = React.createElement(CommentsReadOnlyNoticeView)
	})
end

local frozen = table.freeze({
	comment = ViewRecyclerReact.createRecyclableView(CommentItemView, v7),
	pending = ViewRecyclerReact.createRecyclableView(PendingItemView, v7),
	loadMore = ViewRecyclerReact.createRecyclableView(LoadMoreItemView),
	readOnlyNotice = ViewRecyclerReact.createRecyclableView(ReadOnlyNoticeItemView)
})

local v8 = {}
local onlyNotice = { type = "readOnlyNotice", key = "footer:read-only-notice" }

table.freeze(onlyNotice)
return table.freeze({
	getItemType = function(p2, p3)
		local itemType = frozen[p2.type]
		assert(itemType ~= nil, `CommentsListItems: unknown item type "{tostring(p2.type)}"`)
		return itemType
	end,
	getItemKey = function(p2, p3)
		return p2.key
	end,
	loadMore = function(p2)
		local v9 = v8[p2]

		if v9 ~= nil then
			return v9
		end

		local v10 = { type = "loadMore", key = "footer:load-more", status = p2 }

		table.freeze(v10)
		v8[p2] = v10
		return v10
	end,
	readOnlyNotice = function()
		return onlyNotice
	end
})
