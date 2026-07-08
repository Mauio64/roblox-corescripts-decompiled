local CollectionViews = script:FindFirstAncestor("CollectionViews")
local CollectionViewsParent = CollectionViews.Parent
local React = require(CollectionViewsParent.React)
local Cryo = require(CollectionViewsParent.Cryo)
local ArgCheck = require(CollectionViewsParent.ArgCheck)
local calculateRelativeColumnGap = require(CollectionViews.Grid.calculateRelativeColumnGap)
local calculateSpacePerItem = require(CollectionViews.calculateSpacePerItem)
local FFlagCollectionViewMathChanges = require(CollectionViewsParent.SharedFlags).FFlagCollectionViewMathChanges
local t1 = {
	maxNumRows = 1e999,
	numColumns = 1,
	bufferRowsBelowScreen = 4,
	bufferRowsAboveScreen = 4,
	columnGap = 0,
	sideMargin = 0,
	verticalPadding = 0,
	thresholdRowsFromBottom = 0
}

local function GridOfCollectionItems(t2: {[any]: any}) -- line: 82
	-- upvalues: Cryo (copy), t1 (copy), React (copy), ArgCheck (copy), FFlagCollectionViewMathChanges (copy), calculateSpacePerItem (copy), calculateRelativeColumnGap (copy)
	local v12 = Cryo.Dictionary.join(t1, t2)
	local v13 = React.useRef(nil)
	local v14 = math.min(math.ceil(#v12.items / v12.numColumns), v12.maxNumRows)
	local v15 = v12.itemSizeBinding:map(function(vector2: Vector2) -- line: 90
		-- upvalues: v14 (copy), v12 (copy)
		return v14 * (vector2.Y + v12.verticalPadding) - v12.verticalPadding
	end)
	local v16, v17 = React.useState(-1)
	local v18, v19 = React.useState(-1)
	local v20, v21 = React.useState(v12.bufferRowsBelowScreen + v12.bufferRowsAboveScreen)

	React.useEffect(function() -- line: 103
		-- upvalues: v12 (copy), v13 (copy), v14 (copy), v17 (copy), v19 (copy), v21 (copy)
		local t3 = {}

		if v12.verticalScrollingFrameRef and (v12.verticalScrollingFrameRef.current and v13.current) then
			local current = v13.current
			local current2 = v12.verticalScrollingFrameRef.current
			local Y = v12.itemSizeBinding:getValue().Y
			local AbsolutePositionY = current2.AbsolutePosition.Y
			local AbsoluteWindowSizeY = current2.AbsoluteWindowSize.Y
			local u34 = math.ceil(AbsoluteWindowSizeY / math.max(1, Y + v12.verticalPadding)) + 1

			local function calculateOffsetOfGrid() -- line: 120
				-- upvalues: current (copy), current2 (copy), AbsolutePositionY (ref)
				return current.AbsolutePosition.Y + current2.CanvasPosition.Y - AbsolutePositionY
			end

			local u36 = current.AbsolutePosition.Y + current2.CanvasPosition.Y - AbsolutePositionY

			local function updateRowsToRender() -- line: 127
				-- upvalues: current2 (copy), v12 (copy), v14 (copy), u36 (ref), AbsoluteWindowSizeY (ref), u34 (ref), v17 (copy), v19 (copy)
				local CanvasPositionY = current2.CanvasPosition.Y
				local Y2 = v12.itemSizeBinding:getValue().Y
				local v58 = math.max(1, Y2 + v12.verticalPadding)
				local v59 = v14 * (Y2 + v12.verticalPadding) - v12.verticalPadding
				local v60 = u36 - CanvasPositionY
				local v61 = v12.bufferRowsAboveScreen * v58
				local v62 = v12.bufferRowsBelowScreen * v58
				local n1, n2

				if v60 > AbsoluteWindowSizeY + v62 or v60 + v59 < -v61 then
					n1 = -1
					n2 = -1
				else
					local v65 = math.floor(-v60 / v58)

					n1 = math.max(1, v65 + 1 - v12.bufferRowsAboveScreen)

					local v66 = u34 + v12.bufferRowsBelowScreen
					local v67 = math.max(1, if not (v65 <= 0) then v66 + math.min(v65, v12.bufferRowsAboveScreen) else v66 + v65)

					n2 = math.min(v14, n1 + v67 - 1)
				end

				v17(n1)
				v19(n2)
			end
			local function updateWindowParams() -- line: 172
				-- upvalues: v12 (copy), AbsolutePositionY (ref), current2 (copy), AbsoluteWindowSizeY (ref), u36 (ref), current (copy), u34 (ref), v21 (copy), v14 (copy), updateRowsToRender (copy)
				local v68 = math.max(1, v12.itemSizeBinding:getValue().Y + v12.verticalPadding)

				AbsolutePositionY = current2.AbsolutePosition.Y
				AbsoluteWindowSizeY = current2.AbsoluteWindowSize.Y
				u36 = current.AbsolutePosition.Y + current2.CanvasPosition.Y - AbsolutePositionY
				u34 = math.ceil(AbsoluteWindowSizeY / v68) + 1
				v21((math.min(v14, u34 + v12.bufferRowsBelowScreen + v12.bufferRowsAboveScreen)))
				updateRowsToRender()
			end

			table.insert(t3, current2:GetPropertyChangedSignal("AbsolutePosition"):Connect(updateWindowParams))
			table.insert(t3, current2:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(updateWindowParams))
			table.insert(t3, current2:GetPropertyChangedSignal("CanvasSize"):Connect(updateWindowParams))
			table.insert(t3, current2:GetPropertyChangedSignal("CanvasPosition"):Connect(updateRowsToRender))
			updateWindowParams()
		else
			v17(1)
			v19(v14)
			v21(v14)
		end

		return function() -- line: 213
			-- upvalues: t3 (copy)
			for _, v70 in t3 do
				v70:Disconnect()
			end
		end
	end, {
		v13,
		v14,
		v12.itemSizeBinding,
		v12.verticalScrollingFrameRef,
		v12.verticalPadding,
		v12.bufferRowsAboveScreen,
		v12.bufferRowsBelowScreen,
		v12.onViewableItemsChanged
	})

	local u22 = math.min(v18, v14)
	local v23 = math.max(-1, (v16 - 1) * v12.numColumns + 1)
	local v24 = math.max(-1, (math.min(#v12.items, u22 * v12.numColumns)))

	React.useEffect(function() -- line: 238
		-- upvalues: v12 (copy), v23 (copy), v24 (copy)
		if v12.onViewableItemsChanged then
			v12.onViewableItemsChanged(v23, v24)
		end
	end, {
		v23,
		v24,
		v12.onViewableItemsChanged
	})

	local v25 = React.useRef(nil)

	React.useEffect(function() -- line: 246
		-- upvalues: u22 (ref), v14 (copy), v12 (copy), v25 (copy)
		if u22 >= v14 - v12.thresholdRowsFromBottom and v25.current ~= v12.items and v12.onReachedThresholdFromEnd then
			v12.onReachedThresholdFromEnd()
			v25.current = v12.items
		end
	end, {
		u22,
		v14,
		v12.thresholdRowsFromBottom,
		v12.onReachedThresholdFromEnd,
		v12.items
	})

	local v26 = React.useMemo(function() -- line: 265
		-- upvalues: v16 (copy), u22 (ref), v23 (copy), v24 (copy), v12 (copy), v14 (copy), ArgCheck (copy), React (copy), FFlagCollectionViewMathChanges (copy), calculateSpacePerItem (copy), calculateRelativeColumnGap (copy), v20 (copy)
		local t4 = {}

		if v16 <= 0 or u22 < v16 then
			return nil
		end

		if v23 <= 0 or v24 < v23 then
			return nil
		end

		if v12.numColumns <= 0 or v14 - v16 < 0 then
			return nil
		end

		ArgCheck.assert(v16 >= 1)
		ArgCheck.assert(u22 >= v16 and u22 <= v14)

		if v16 > 1 then
			local v40 = v16 - 1

			t4.Padding = React.createElement("UIPadding", {
				PaddingTop = v12.itemSizeBinding:map(function(vector2: Vector2) -- line: 283
					-- upvalues: v40 (copy), v12 (copy)
					return UDim.new(0, v40 * (vector2.Y + v12.verticalPadding))
				end)
			})
		end

		local v41 = v14 - v16 + 1

		ArgCheck.assert(v41 >= 1)
		ArgCheck.assert(v12.numColumns >= 1)

		local uDim2, uDim2_2

		if FFlagCollectionViewMathChanges then
			local v42 = calculateSpacePerItem(v12.numColumns, v12.columnGap)
			local v43 = calculateSpacePerItem(v41, v12.verticalPadding)

			uDim2 = UDim2.new(1 / v12.numColumns, -v42.gapOffsetPerItem, 1 / v41, -v43.gapOffsetPerItem)
			uDim2_2 = UDim2.new(0, v42.adjustedGap, 0, v43.adjustedGap)
		else
			local v46 = v12.numColumns - 1
			local v47 = v41 - 1

			uDim2 = UDim2.new(1 / v12.numColumns, math.floor(-(v46 / v12.numColumns) * v12.columnGap), 1 / v41, (math.floor(-(v47 / v41) * v12.verticalPadding)))

			local v48 = math.floor(v46 / v12.numColumns * v12.columnGap) * v12.numColumns - v12.columnGap * v46
			local v49 = v12.columnGap + v48 / v46

			uDim2_2 = if not v12.disableRelativeGap then v12.itemSizeBinding:map(function(vector2: Vector2) -- line: 321
				-- upvalues: calculateRelativeColumnGap (copy), v12 (copy)
				local v73 = calculateRelativeColumnGap(v12.numColumns, v12.columnGap, vector2.X, v12.sideMargin)

				return UDim2.new(v73, 0, 0, v12.verticalPadding)
			end) else UDim2.new(0, v49, 0, v12.verticalPadding)
		end

		t4.Layout = React.createElement("UIGridLayout", {
			FillDirectionMaxCells = v12.numColumns,
			CellPadding = uDim2_2,
			CellSize = uDim2,
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			SortOrder = Enum.SortOrder.LayoutOrder
		})
		ArgCheck.assert(v23 >= 1)
		ArgCheck.assert(v24 >= v23 and v24 <= #v12.items)

		for i = v23, v24 do
			if i <= #v12.items then
				local v51 = math.ceil(i / v12.numColumns)
				local v52 = v12.items[i]
				local v53, v54 = v12.renderItem(v52, i, UDim2.fromScale(1, 1), v51)

				t4[`{ v54 }{ i % (v20 * v12.numColumns) }`] = v53
			end
		end

		return t4
	end, {
		v12.columnGap,
		v12.numColumns,
		v12.itemSizeBinding,
		v16,
		u22,
		v12.items,
		v12.renderItem,
		v12.verticalPadding,
		v20,
		v14,
		if FFlagCollectionViewMathChanges then nil else v12.sideMargin,
		v23,
		v24,
		if FFlagCollectionViewMathChanges then nil else v12.disableRelativeGap
	})

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		ref = v13,
		Size = v15:map(function(p1) -- line: 371
			return UDim2.new(1, 0, 0, p1)
		end),
		LayoutOrder = v12.LayoutOrder,
		Position = v12.Position
	}, v26)
end

return React.memo(GridOfCollectionItems)
