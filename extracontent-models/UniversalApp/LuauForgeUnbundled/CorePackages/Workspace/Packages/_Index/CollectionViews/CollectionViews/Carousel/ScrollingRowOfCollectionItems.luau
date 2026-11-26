local React = require("@game/CorePackages/Workspace/Packages/_Workspace/CollectionViews/React")
local ArgCheck = require("@game/CorePackages/Workspace/Packages/_Index/CollectionViews/ArgCheck")

local useHorizontalScrolledToEndThreshold = require("@game/CorePackages/Workspace/Packages/_Index/CollectionViews/CollectionViews/Carousel/useHorizontalScrolledToEndThreshold")
local useHorizontalWindowStartIndex = require("@game/CorePackages/Workspace/Packages/_Index/CollectionViews/CollectionViews/Carousel/useHorizontalWindowStartIndex")
local module5 = require("@game/CorePackages/Workspace/Packages/_Index/CollectionViews/CollectionViews/Carousel/RowOfCollectionItems")

local function getNumToRenderWithVirtualization(p2, p3, value)
	if p3 == 0 then
		return 0
	end

	return (math.min(p3 + (value or 6), p2))
end

local function ScrollingRowOfCollectionItems(props)
	local ref = React.useRef(nil)
	local v5 = React.useCallback(function(current)
		ref.current = current

		if props.onScrollingFrameRefCallback then
			props.onScrollingFrameRefCallback(current)
		end
	end, { props.onScrollingFrameRefCallback })

	useHorizontalScrolledToEndThreshold(ref, props.thresholdFromEnd, props.onReachedThresholdFromEnd, props.ScrollingEnabled)

	ArgCheck.assert(props.totalItemsOnCanvas >= 0)
	ArgCheck.assert(props.numColumns >= 1)
	ArgCheck.assert(props.columnGap >= 0)
	local v6

	if props.numItemsToRenderOffScreen == -1 then
		v6 = false
	else
		v6 = props.ScrollingEnabled and props.totalItemsOnCanvas > props.numColumns * 2
	end

	local v7

	if v6 then
		local totalItemsOnCanvas = props.totalItemsOnCanvas
		local numColumns = props.numColumns
		local numItemsToRenderOffScreen = props.numItemsToRenderOffScreen
		v7 = numColumns == 0 and 0
			or math.min(numColumns + (numItemsToRenderOffScreen or 6), totalItemsOnCanvas)
	else
		v7 = math.min(props.totalItemsOnCanvas, #props.items)
	end

	local v8 = math.max(props.numColumns, props.totalItemsOnCanvas)
	ArgCheck.assert(v7 >= 0)

	local v9 = math.min(useHorizontalWindowStartIndex(ref, props.itemSizeBinding, props.columnGap, v6), #props.items)

	local v10 = math.max(0, (math.min(props.totalItemsOnCanvas, v9 + v7 - 1)))

	ArgCheck.assert(
		v9 >= 0 and v9 <= #props.items,
		`startingIndex: {v9} failed check >= 0 and <= {#props.items}`
	)

	ArgCheck.assert(
		v9 <= v10 and v10 <= #props.items,
		`endingIndex: {v10} failed check >= {v9} and <= {#props.items}`
	)

	React.useEffect(function()
		if props.onViewableItemsChanged then
			props.onViewableItemsChanged(v9, v10)
		end
	end, { v9, v10, props.onViewableItemsChanged })

	local createElement = React.createElement
	local v14

	if props.Size then
		v14 = props.Size
	else
		v14 = props.itemSizeBinding:map(function(p2)
			return UDim2.new(1, 0, 0, p2.Y)
		end)
	end

	return createElement("ScrollingFrame", {
		Size = v14,
		Position = props.Position,
		LayoutOrder = props.LayoutOrder,
		ScrollBarThickness = 0,
		BackgroundTransparency = 1,
		ClipsDescendants = false,
		CanvasSize = props.itemSizeBinding:map(function(p2)
			local v15 = math.max(0, v8 * (p2.X + props.columnGap) - props.columnGap)
			return UDim2.new(0, v15, 0, p2.Y)
		end),
		ScrollingEnabled = props.ScrollingEnabled and props.totalItemsOnCanvas > props.numColumns,
		ScrollingDirection = Enum.ScrollingDirection.X,
		ElasticBehavior = Enum.ElasticBehavior.Always,
		Selectable = false,
		[React.Change.CanvasPosition] = props.onChangeCanvasPosition,
		ref = v5,
		AutomaticSize = props.AutomaticSize
	}, {
		RowOfCollectionItems = React.createElement(module5, {
			startingIndex = v9,
			endingIndex = v10,
			numToRender = v7,
			items = props.items,
			totalItemsOnCanvas = props.totalItemsOnCanvas,
			columnGap = props.columnGap,
			renderItem = props.renderItem,
			sideMargin = props.sideMargin,
			numItemsForSizing = v8
		})
	})
end

return React.memo(ScrollingRowOfCollectionItems)
