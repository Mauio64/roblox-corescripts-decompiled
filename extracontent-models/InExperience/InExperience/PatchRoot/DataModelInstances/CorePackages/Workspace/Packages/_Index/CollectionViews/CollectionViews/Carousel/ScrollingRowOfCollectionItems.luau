local CollectionViews = script:FindFirstAncestor("CollectionViews")
local CollectionViewsParent = CollectionViews.Parent
local React = require(CollectionViewsParent.React)
local ArgCheck = require(CollectionViewsParent.ArgCheck)
local useHorizontalScrolledToEndThreshold = require(CollectionViews.Carousel.useHorizontalScrolledToEndThreshold)
local useHorizontalWindowStartIndex = require(CollectionViews.Carousel.useHorizontalWindowStartIndex)
local RowOfCollectionItems = require(CollectionViews.Carousel.RowOfCollectionItems)

require(CollectionViews.Carousel.calculateCarouselSpacingMetrics)

local SharedFlags = require(CollectionViewsParent.SharedFlags)
local FFlagCollectionViewMathChanges = SharedFlags.FFlagCollectionViewMathChanges
local FFlagLuaAppFixCarouselCanvasOverflow = SharedFlags.FFlagLuaAppFixCarouselCanvasOverflow

local function getNumToRenderWithVirtualization(n1: number, n2: number, n3: number?) -- line: 81
	if n2 == 0 then
		return 0
	end

	return (math.min(n2 + (n3 or 6), n1))
end
local function ScrollingRowOfCollectionItems(t1: {[any]: any}) -- line: 98
	-- upvalues: React (copy), useHorizontalScrolledToEndThreshold (copy), ArgCheck (copy), useHorizontalWindowStartIndex (copy), FFlagCollectionViewMathChanges (copy), FFlagLuaAppFixCarouselCanvasOverflow (copy), RowOfCollectionItems (copy)
	local v17 = React.useRef(nil)
	local v18 = React.useCallback(function(p1) -- line: 101
		-- upvalues: v17 (copy), t1 (copy)
		v17.current = p1

		if t1.onScrollingFrameRefCallback then
			t1.onScrollingFrameRefCallback(p1)
		end
	end, { t1.onScrollingFrameRefCallback })

	useHorizontalScrolledToEndThreshold(v17, t1.thresholdFromEnd, t1.onReachedThresholdFromEnd, t1.ScrollingEnabled)
	ArgCheck.assert(t1.totalItemsOnCanvas >= 0)
	ArgCheck.assert(t1.numColumns >= 1)
	ArgCheck.assert(t1.columnGap >= 0)

	local v19 = t1.numItemsToRenderOffScreen ~= -1 and (t1.ScrollingEnabled and t1.totalItemsOnCanvas > t1.numColumns * 2)
	local v23

	if v19 then
		local totalItemsOnCanvas = t1.totalItemsOnCanvas
		local numColumns = t1.numColumns
		local numItemsToRenderOffScreen = t1.numItemsToRenderOffScreen

		v23 = if numColumns ~= 0 then math.min(numColumns + (numItemsToRenderOffScreen or 6), totalItemsOnCanvas) else 0
	else
		v23 = math.min(t1.totalItemsOnCanvas, #t1.items)
	end

	local v24 = math.max(t1.numColumns, t1.totalItemsOnCanvas)

	ArgCheck.assert(v23 >= 0)

	local v25 = math.min(useHorizontalWindowStartIndex(v17, if not FFlagCollectionViewMathChanges then t1.itemSizeBinding else nil, if not FFlagCollectionViewMathChanges then t1.columnGap else nil, v19, if not FFlagCollectionViewMathChanges then nil else t1.numColumns, if not FFlagCollectionViewMathChanges then nil else t1.spacingMetricsBinding), #t1.items)
	local v26 = math.max(0, (math.min(t1.totalItemsOnCanvas, v25 + v23 - 1)))

	ArgCheck.assert(v25 >= 0 and v25 <= #t1.items, `startingIndex: { v25 } failed check >= 0 and <= { #t1.items }`)
	ArgCheck.assert(v25 <= v26 and v26 <= #t1.items, `endingIndex: { v26 } failed check >= { v25 } and <= { #t1.items }`)
	React.useEffect(function() -- line: 165
		-- upvalues: t1 (copy), v25 (copy), v26 (copy)
		if t1.onViewableItemsChanged then
			t1.onViewableItemsChanged(v25, v26)
		end
	end, {
		v25,
		v26,
		t1.onViewableItemsChanged
	})

	local v27 = nil

	if FFlagCollectionViewMathChanges then
		v27 = React.useMemo(function() -- line: 173
			-- upvalues: React (copy), t1 (copy), FFlagLuaAppFixCarouselCanvasOverflow (copy), v24 (copy)
			return React.joinBindings({
				t1.spacingMetricsBinding,
				t1.itemSizeBinding
			}):map(function(p2) -- line: 177
				-- upvalues: FFlagLuaAppFixCarouselCanvasOverflow (copy), v24 (copy), t1 (copy)
				local v34 = p2[1]
				local v35 = p2[2]
				local v36 = not (v34.effectiveWidth > 0) and 0 or if not FFlagLuaAppFixCarouselCanvasOverflow then (v24 - t1.numColumns) * v34.stride + v34.containerWidth else (v24 - 1) * v34.stride + v34.renderedItemWidth

				return UDim2.fromOffset(math.max(0, v36), (math.ceil(v35.Y)))
			end)
		end, {
			t1.spacingMetricsBinding,
			t1.itemSizeBinding,
			t1.numColumns,
			v24
		})
	end

	return React.createElement("ScrollingFrame", {
		Size = if not t1.Size then t1.itemSizeBinding:map(function(vector2: Vector2) -- line: 196
			return UDim2.new(1, 0, 0, vector2.Y)
		end) else t1.Size,
		Position = t1.Position,
		LayoutOrder = t1.LayoutOrder,
		ScrollBarThickness = 0,
		BackgroundTransparency = 1,
		ClipsDescendants = false,
		CanvasSize = if not FFlagCollectionViewMathChanges then t1.itemSizeBinding:map(function(vector2: Vector2) -- line: 206
			-- upvalues: v24 (copy), t1 (copy)
			local v31 = math.max(0, v24 * (vector2.X + t1.columnGap) - t1.columnGap)

			return UDim2.new(0, v31, 0, vector2.Y)
		end) else v27,
		ScrollingEnabled = t1.ScrollingEnabled and t1.totalItemsOnCanvas > t1.numColumns,
		ScrollingDirection = Enum.ScrollingDirection.X,
		ElasticBehavior = Enum.ElasticBehavior.Always,
		Selectable = false,
		[React.Change.CanvasPosition] = t1.onChangeCanvasPosition,
		[React.Change.AbsoluteSize] = if not FFlagCollectionViewMathChanges then nil else t1.onScrollingFrameAbsoluteSizeChanged,
		ref = v18,
		AutomaticSize = t1.AutomaticSize
	}, {
		RowOfCollectionItems = if not FFlagCollectionViewMathChanges then React.createElement(RowOfCollectionItems, {
			startingIndex = v25,
			endingIndex = v26,
			numToRender = v23,
			items = t1.items,
			totalItemsOnCanvas = t1.totalItemsOnCanvas,
			columnGap = t1.columnGap,
			renderItem = t1.renderItem,
			sideMargin = t1.sideMargin,
			numItemsForSizing = v24
		}) else React.createElement("Frame", {
			BackgroundTransparency = 1,
			ClipsDescendants = false,
			Size = t1.spacingMetricsBinding:map(function(p3) -- line: 224
				return UDim2.new(0, p3.effectiveWidth, 1, 0)
			end)
		}, {
			RowOfCollectionItems = React.createElement(RowOfCollectionItems, {
				startingIndex = v25,
				endingIndex = v26,
				numToRender = v23,
				items = t1.items,
				totalItemsOnCanvas = t1.totalItemsOnCanvas,
				columnGap = t1.columnGap,
				renderItem = t1.renderItem,
				sideMargin = t1.sideMargin,
				numColumns = t1.numColumns,
				spacingMetricsBinding = t1.spacingMetricsBinding
			})
		})
	})
end

return React.memo(ScrollingRowOfCollectionItems)
