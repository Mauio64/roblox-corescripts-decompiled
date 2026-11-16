local CollectionViews = script:FindFirstAncestor("CollectionViews")
local parent = CollectionViews.Parent
local React = require(parent.React)
local ArgCheck = require(parent.ArgCheck)

local useHorizontalScrolledToEndThreshold = require(CollectionViews.Carousel.useHorizontalScrolledToEndThreshold)
local useHorizontalWindowStartIndex = require(CollectionViews.Carousel.useHorizontalWindowStartIndex)
local RowOfCollectionItems = require(CollectionViews.Carousel.RowOfCollectionItems)

local function getNumToRenderWithVirtualization(totalItemsOnCanvas: number, numColumns: number, numItemsToRenderOffScreen: number?) -- 1 equivalent call inferred from this helper
	if numColumns == 0 then
		return 0
	end

	return (math.min(numColumns + (numItemsToRenderOffScreen or 6), totalItemsOnCanvas))
end

local function ScrollingRowOfCollectionItems(props)
	local ref = React.useRef(nil)
	local ref2 = React.useCallback(function(current)
		ref.current = current

		if props.onScrollingFrameRefCallback then
			props.onScrollingFrameRefCallback(current)
		end
	end, { props.onScrollingFrameRefCallback })

	useHorizontalScrolledToEndThreshold(
		ref,
		props.thresholdFromEnd,
		props.onReachedThresholdFromEnd,
		props.ScrollingEnabled
	)

	ArgCheck.assert(props.totalItemsOnCanvas >= 0)
	ArgCheck.assert(props.numColumns >= 1)
	ArgCheck.assert(props.columnGap >= 0)
	local v

	if props.numItemsToRenderOffScreen == -1 then
		v = false
	else
		v = props.ScrollingEnabled and props.totalItemsOnCanvas > props.numColumns * 2
	end

	local numToRender

	if v then
		numToRender = getNumToRenderWithVirtualization( -- inferred equivalent call
			props.totalItemsOnCanvas,
			props.numColumns,
			props.numItemsToRenderOffScreen
		)
	else
		numToRender = math.min(props.totalItemsOnCanvas, #props.items)
	end

	local numItemsForSizing = math.max(props.numColumns, props.totalItemsOnCanvas)
	ArgCheck.assert(numToRender >= 0)

	local startingIndex = math.min(
		useHorizontalWindowStartIndex(ref, props.itemSizeBinding, props.columnGap, v),
		#props.items
	)

	local endingIndex = math.max(0, (math.min(props.totalItemsOnCanvas, startingIndex + numToRender - 1)))

	ArgCheck.assert(
		startingIndex >= 0 and startingIndex <= #props.items,
		`startingIndex: {startingIndex} failed check >= 0 and <= {#props.items}`
	)

	ArgCheck.assert(
		startingIndex <= endingIndex and endingIndex <= #props.items,
		`endingIndex: {endingIndex} failed check >= {startingIndex} and <= {#props.items}`
	)

	React.useEffect(function()
		if props.onViewableItemsChanged then
			props.onViewableItemsChanged(startingIndex, endingIndex)
		end
	end, { startingIndex, endingIndex, props.onViewableItemsChanged })

	local createElement = React.createElement
	local size

	if props.Size then
		size = props.Size
	else
		size = props.itemSizeBinding:map(function(vector2: Vector2)
			return UDim2.new(1, 0, 0, vector2.Y)
		end)
	end

	return createElement("ScrollingFrame", {
		Size = size,
		Position = props.Position,
		LayoutOrder = props.LayoutOrder,
		ScrollBarThickness = 0,
		BackgroundTransparency = 1,
		ClipsDescendants = false,
		CanvasSize = props.itemSizeBinding:map(function(vector2: Vector2)
			local v2 = math.max(0, numItemsForSizing * (vector2.X + props.columnGap) - props.columnGap)
			return UDim2.new(0, v2, 0, vector2.Y)
		end),
		ScrollingEnabled = props.ScrollingEnabled and props.totalItemsOnCanvas > props.numColumns,
		ScrollingDirection = Enum.ScrollingDirection.X,
		ElasticBehavior = Enum.ElasticBehavior.Always,
		Selectable = false,
		[React.Change.CanvasPosition] = props.onChangeCanvasPosition,
		ref = ref2,
		AutomaticSize = props.AutomaticSize
	}, {
		RowOfCollectionItems = React.createElement(RowOfCollectionItems, {
			startingIndex = startingIndex,
			endingIndex = endingIndex,
			numToRender = numToRender,
			items = props.items,
			totalItemsOnCanvas = props.totalItemsOnCanvas,
			columnGap = props.columnGap,
			renderItem = props.renderItem,
			sideMargin = props.sideMargin,
			numItemsForSizing = numItemsForSizing
		})
	})
end

return React.memo(ScrollingRowOfCollectionItems)
