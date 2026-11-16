local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")
local ViewRecyclerReact = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/ViewRecyclerReact")

local CommentsListItems = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/List/CommentsList/CommentsListItems")
local CommentsListRowContext = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/List/CommentsList/CommentsListRowContext")
require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/List/Rows/CommentRowTypes")
local FFlagMomentsCommentsAttachSheetScroller = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsCommentsAttachSheetScroller")

local function AttachedCommentsListView(props)
	return React.createElement(CommentsListRowContext.CommentsListRowContext.Provider, {
		value = props.row
	}, {
		List = React.createElement(ViewRecyclerReact.VirtualList, {
			scrollingFrame = props.scrollingFrame,
			data = props.data,
			layout = props.layout,
			axis = ViewRecyclerReact.Axis.Y,
			itemType = CommentsListItems.getItemType,
			overscan = 2,
			endReachedThreshold = 240,
			onEndReached = props.onEndReached,
			onViewportChanged = props.onViewportChanged,
			onContentLengthChanged = props.onContentLengthChanged,
			onVisibleItemsPresented = props.onVisibleItemsPresented,
			autoScrollOnChange = ViewRecyclerReact.AutoScrollPolicy.WhenAtStart,
			autoScrollThreshold = 33,
			scrollingFrameRef = props.listScrollingFrameRef,
			listRef = props.listRef
		})
	})
end

local function CommentsListView(props)
	if FFlagMomentsCommentsAttachSheetScroller then
		return React.createElement(AttachedCommentsListView, props)
	end

	local udim = UDim.new(0, -2 * props.rowBleed)
	return React.createElement(Foundation.View, {
		Size = UDim2.fromScale(1, 1),
		padding = { left = udim, right = udim },
		testId = "moments-comments-list"
	}, {
		Rows = React.createElement(CommentsListRowContext.CommentsListRowContext.Provider, {
			value = props.row
		}, {
			List = React.createElement(ViewRecyclerReact.VirtualList, {
				data = props.data,
				layout = props.layout,
				axis = ViewRecyclerReact.Axis.Y,
				itemType = CommentsListItems.getItemType,
				overscan = 2,
				endReachedThreshold = 240,
				onEndReached = props.onEndReached,
				onViewportChanged = props.onViewportChanged,
				onContentLengthChanged = props.onContentLengthChanged,
				onVisibleRangeChanged = props.onVisibleRangeChanged,
				autoScrollOnChange = ViewRecyclerReact.AutoScrollPolicy.WhenAtStart,
				autoScrollThreshold = 33,
				scrollingFrameRef = props.listScrollingFrameRef,
				listRef = props.listRef,
				scrollingFrameProps = {
					Name = "MomentsCommentsListScrollingFrame",
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					ScrollBarThickness = 0,
					Selectable = false,
					ScrollingEnabled = props.isScrollingEnabled
				}
			})
		})
	})
end

return CommentsListView
