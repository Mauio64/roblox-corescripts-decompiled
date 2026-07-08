local CollectionViews = script:FindFirstAncestor("CollectionViews")
local CollectionViewsParent = CollectionViews.Parent
local React = require(CollectionViewsParent.React)
local ArgCheck = require(CollectionViewsParent.ArgCheck)
local calculateSpacePerItem = require(CollectionViews.calculateSpacePerItem)

require(CollectionViews.Carousel.calculateCarouselSpacingMetrics)

local FFlagCollectionViewMathChanges = require(CollectionViewsParent.SharedFlags).FFlagCollectionViewMathChanges

local function RowOfCollectionItems(t1: {[any]: any}) -- line: 52
	-- upvalues: React (copy), FFlagCollectionViewMathChanges (copy), calculateSpacePerItem (copy), ArgCheck (copy)
	local v9 = React.useMemo(function() -- line: 54
		-- upvalues: t1 (copy), FFlagCollectionViewMathChanges (copy), calculateSpacePerItem (copy), React (copy), ArgCheck (copy)
		if t1.numToRender == 0 or if not FFlagCollectionViewMathChanges then t1.numItemsForSizing == 0 else t1.numColumns == 0 then
			return nil
		end

		local v10 = t1.startingIndex - 1
		local t2 = {}
		local uDim2, adjustedGap

		if FFlagCollectionViewMathChanges then
			local numColumns = t1.numColumns
			local v13 = calculateSpacePerItem(numColumns, t1.columnGap)

			uDim2 = UDim2.new(1 / numColumns, -v13.gapOffsetPerItem, 1, 0)
			adjustedGap = v13.adjustedGap
		else
			local numItemsForSizing = t1.numItemsForSizing
			local v17 = numItemsForSizing - 1
			local v18 = math.floor(v17 / numItemsForSizing * t1.columnGap)

			uDim2 = UDim2.new(1 / numItemsForSizing, -v18, 1, 0)

			local v19 = v18 * numItemsForSizing - t1.columnGap * v17

			adjustedGap = t1.columnGap + v19 / v17
		end

		t2.Layout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Horizontal,
			Padding = UDim.new(0, adjustedGap),
			HorizontalAlignment = Enum.HorizontalAlignment.Left
		})

		if v10 > 0 then
			t2.Padding = React.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 0,
				Size = if not FFlagCollectionViewMathChanges then UDim2.new(v10 * uDim2.X.Scale, (v10 - 1) * adjustedGap + v10 * uDim2.X.Offset, 0, 0) else t1.spacingMetricsBinding:map(function(p1) -- line: 100
					-- upvalues: v10 (copy)
					local v25 = v10 * p1.stride - p1.renderedGap

					return UDim2.fromOffset(math.max(0, v25), 0)
				end)
			})
		end

		ArgCheck.assert(t1.startingIndex >= 1 and t1.startingIndex <= #t1.items)
		ArgCheck.assert(t1.endingIndex >= t1.startingIndex and t1.endingIndex <= #t1.items)

		for i = t1.startingIndex, t1.endingIndex do
			if i >= 1 and i <= #t1.items then
				local v21 = t1.items[i]
				local v22, v23 = t1.renderItem(v21, i, uDim2)

				t2[v23 .. tostring(i % t1.numToRender + 1)] = v22
			end
		end

		return t2
	end, {
		t1.columnGap,
		t1.startingIndex,
		t1.endingIndex,
		t1.items,
		t1.numToRender,
		t1.renderItem,
		t1.sideMargin,
		t1.totalItemsOnCanvas,
		if not FFlagCollectionViewMathChanges then t1.numItemsForSizing else t1.numColumns,
		if not FFlagCollectionViewMathChanges then nil else t1.spacingMetricsBinding
	})

	return React.createElement(React.Fragment, nil, v9)
end

return React.memo(RowOfCollectionItems)
