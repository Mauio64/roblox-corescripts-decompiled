local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")

local FFlagMomentsCommentsRevealAfterMeasure = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsCommentsRevealAfterMeasure")
local FFlagMomentsCommentsAttachSheetScroller = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsCommentsAttachSheetScroller")

local CommentsListContainer = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/List/CommentsList/CommentsListContainer")
local CommentsPanelStateView = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/Panel/CommentsPanelStateView")
local CommentsReadOnlyNoticeView = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/Panel/CommentsReadOnlyNoticeView")
require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/Panel/getCommentsPanelState")
local ScrollingFrameCover = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/Panel/CommentsPanelBody/ScrollingFrameCover")

local function CommentsPanelBodyView(props)
	local feedItemId = props.feedItemId
	local v5 = props.contentState == "list" and feedItemId ~= nil
	local v6 = props.contentState == "loading"

	local v7 = FFlagMomentsCommentsAttachSheetScroller and v5
	local v8 = v5 and not v7
	local v9 = "Content"
	local v10

	if v5 then
		v9 = `List:{feedItemId}:{props.sessionId}`

		if not (v7 and props.scrollingFrame == nil) then
			local createElement = React.createElement
			local v12 = {
				feedItemId = feedItemId,
				sessionId = props.sessionId,
				isReadOnly = props.isReadOnly,
				scrollingFrame = 0,
				onRevealed = 0
			}
			local v13 = if FFlagMomentsCommentsAttachSheetScroller then props.scrollingFrame else nil
			v12.scrollingFrame = v13
			local v14 = if FFlagMomentsCommentsRevealAfterMeasure then props.onListRevealed else nil
			v12.onRevealed = v14
			v10 = createElement(CommentsListContainer, v12)
		end
	else
		local createElement = React.createElement
		local v12 = {
			state = props.contentState == "list" and "unavailable" or props.contentState,
			isReadOnly = props.isReadOnly,
			onRetry = 0
		}
		local v13 = if props.canRetryInitial then props.onRetryInitial else nil
		v12.onRetry = v13
		v10 = createElement(CommentsPanelStateView, v12)
	end

	local v11 = nil

	if FFlagMomentsCommentsRevealAfterMeasure and v7 and not props.isListRevealed then
		if props.scrollingFrame ~= nil then
			v11 = React.createElement(
				ScrollingFrameCover,
				{
					scrollingFrame = props.scrollingFrame,
					Visible = props.revealPlaceholdersVisible,
					testId = "moments-comments-panel-reveal-placeholders"
				},
				{
					Inset = React.createElement(Foundation.View, {
						tag = "size-full padding-x-xlarge"
					}, {
						Placeholders = React.createElement(CommentsPanelStateView, {
							state = "loading"
						})
					})
				}
			)
		end
	elseif FFlagMomentsCommentsRevealAfterMeasure and v5 and not props.isListRevealed then
		v11 = React.createElement(
			Foundation.View,
			{
				ZIndex = 2,
				tag = "size-full bg-surface-100",
				testId = "moments-comments-panel-reveal-placeholders"
			},
			{
				Placeholders = React.createElement(CommentsPanelStateView, { state = "loading" })
			}
		)
	end

	local createElement = React.createElement
	local view = Foundation.View
	local v12 = {
		tag = {
			["col size-full"] = v8,
			["col size-full-0 auto-y"] = not v8
		},
		sizeConstraint = not v5 and {
			MinSize = props.stateMinHeight:map(function(p2)
				return Vector2.new(0, p2)
			end),
			MaxSize = nil
		} or nil,
		testId = "moments-comments-panel-body"
	}

	local v13 = {
		Content = React.createElement(Foundation.View, {
			LayoutOrder = 1,
			tag = {
				["size-full"] = v8,
				["size-full-0"] = not v8,
				["auto-y"] = not (v8 or v6),
				fill = not v5
			},
			testId = "moments-comments-panel-content"
		}, { [v9] = v10, RevealPlaceholders = v11 }),
		ReadOnly = 0
	}

	local v14 = if props.isReadOnly and not v5 then React.createElement(
		Foundation.View,
		{
			LayoutOrder = 2,
			tag = "size-full-0 auto-y",
			testId = "moments-comments-panel-read-only"
		},
		{ Notice = React.createElement(CommentsReadOnlyNoticeView) }
	) else nil
	v13.ReadOnly = v14
	return createElement(view, v12, v13)
end

return CommentsPanelBodyView
