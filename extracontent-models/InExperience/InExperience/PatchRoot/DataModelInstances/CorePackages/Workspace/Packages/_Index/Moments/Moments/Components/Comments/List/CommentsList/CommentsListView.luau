local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local ViewRecycler = require(parent.ViewRecycler)

local CommentsListItems = require(script.Parent.CommentsListItems)
local CommentsListRowContext = require(script.Parent.CommentsListRowContext)
require(script.Parent.Parent.Rows.CommentRowTypes)
local FFlagMomentsCommentsAttachSheetScroller = require(Moments.Flags.FFlagMomentsCommentsAttachSheetScroller)

local function AttachedCommentsListView(props)
	return React.createElement(CommentsListRowContext.CommentsListRowContext.Provider, {
		value = props.row
	}, {
		List = React.createElement(ViewRecycler.VirtualList, {
			scrollingFrame = props.scrollingFrame,
			data = props.data,
			layout = props.layout,
			axis = ViewRecycler.Axis.Y,
			itemType = CommentsListItems.getItemType,
			overscan = 2,
			endReachedThreshold = 240,
			onEndReached = props.onEndReached,
			onViewportChanged = props.onViewportChanged,
			onContentLengthChanged = props.onContentLengthChanged,
			onVisibleItemsPresented = props.onVisibleItemsPresented,
			autoScrollOnChange = ViewRecycler.AutoScrollPolicy.WhenAtStart,
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

	local udim = UDim.new(0, props.rowBleed * -2)
	return React.createElement(Foundation.View, {
		Size = UDim2.fromScale(1, 1),
		padding = { left = udim, right = udim },
		testId = "moments-comments-list"
	}, {
		Rows = React.createElement(CommentsListRowContext.CommentsListRowContext.Provider, {
			value = props.row
		}, {
			List = React.createElement(ViewRecycler.VirtualList, {
				data = props.data,
				layout = props.layout,
				axis = ViewRecycler.Axis.Y,
				itemType = CommentsListItems.getItemType,
				overscan = 2,
				endReachedThreshold = 240,
				onEndReached = props.onEndReached,
				onViewportChanged = props.onViewportChanged,
				onContentLengthChanged = props.onContentLengthChanged,
				onVisibleRangeChanged = props.onVisibleRangeChanged,
				autoScrollOnChange = ViewRecycler.AutoScrollPolicy.WhenAtStart,
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
