local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local FFlagMomentsCommentsRevealAfterMeasure = require(Moments.Flags.FFlagMomentsCommentsRevealAfterMeasure)
local FFlagMomentsCommentsAttachSheetScroller = require(Moments.Flags.FFlagMomentsCommentsAttachSheetScroller)

local CommentsListContainer = require(Moments.Components.Comments.List.CommentsList.CommentsListContainer)
local CommentsPanelStateView = require(script.Parent.Parent.CommentsPanelStateView)
local CommentsReadOnlyNoticeView = require(script.Parent.Parent.CommentsReadOnlyNoticeView)
require(script.Parent.Parent.getCommentsPanelState)
local ScrollingFrameCover = require(script.Parent.ScrollingFrameCover)

local function CommentsPanelBodyView(props)
	local feedItemId = props.feedItemId
	local v

	if props.contentState == "list" then
		v = feedItemId ~= nil
	else
		v = false
	end

	local v2 = props.contentState == "loading"

	local v3 = FFlagMomentsCommentsAttachSheetScroller and v
	local v4 = v and not v3
	local v5 = "Content"
	local v6

	if v then
		v5 = `List:{feedItemId}:{props.sessionId}`

		if not (v3 and props.scrollingFrame == nil) then
			local createElement = React.createElement
			local v7 = {
				feedItemId = feedItemId,
				sessionId = props.sessionId,
				isReadOnly = props.isReadOnly,
				scrollingFrame = 0,
				onRevealed = 0
			}
			local scrollingFrame

			if FFlagMomentsCommentsAttachSheetScroller then
				scrollingFrame = props.scrollingFrame
			end

			v7.scrollingFrame = scrollingFrame
			local onRevealed

			if FFlagMomentsCommentsRevealAfterMeasure then
				onRevealed = props.onListRevealed
			end

			v7.onRevealed = onRevealed
			v6 = createElement(CommentsListContainer, v7)
		end
	else
		local createElement = React.createElement
		local v7 = {
			state = props.contentState == "list" and "unavailable" or props.contentState,
			isReadOnly = props.isReadOnly,
			onRetry = 0
		}
		local onRetry

		if props.canRetryInitial then
			onRetry = props.onRetryInitial
		end

		v7.onRetry = onRetry
		v6 = createElement(CommentsPanelStateView, v7)
	end

	local revealPlaceholders = nil

	if FFlagMomentsCommentsRevealAfterMeasure and v3 and not props.isListRevealed then
		if props.scrollingFrame ~= nil then
			revealPlaceholders = React.createElement(
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
	elseif FFlagMomentsCommentsRevealAfterMeasure and v and not props.isListRevealed then
		revealPlaceholders = React.createElement(
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
	local v7 = {
		tag = {
			["col size-full"] = v4,
			["col size-full-0 auto-y"] = not v4
		},
		sizeConstraint = not v and {
			MinSize = props.stateMinHeight:map(function(p: number)
				return Vector2.new(0, p)
			end),
			MaxSize = nil
		} or nil,
		testId = "moments-comments-panel-body"
	}

	local v8 = {
		Content = React.createElement(Foundation.View, {
			LayoutOrder = 1,
			tag = {
				["size-full"] = v4,
				["size-full-0"] = not v4,
				["auto-y"] = not (v4 or v2),
				fill = not v
			},
			testId = "moments-comments-panel-content"
		}, { [v5] = v6, RevealPlaceholders = revealPlaceholders }),
		ReadOnly = 0
	}
	local readOnly

	if props.isReadOnly and not v then
		readOnly = React.createElement(
			Foundation.View,
			{
				LayoutOrder = 2,
				tag = "size-full-0 auto-y",
				testId = "moments-comments-panel-read-only"
			},
			{
				Notice = React.createElement(CommentsReadOnlyNoticeView)
			}
		)
	end

	v8.ReadOnly = readOnly
	return createElement(view, v7, v8)
end

return CommentsPanelBodyView
