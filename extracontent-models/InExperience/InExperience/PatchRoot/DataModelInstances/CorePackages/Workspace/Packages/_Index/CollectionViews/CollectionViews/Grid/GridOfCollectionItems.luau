local CollectionViews = script:FindFirstAncestor("CollectionViews")
local CollectionViewsParent = CollectionViews.Parent
local React = require(CollectionViewsParent.React)
local Cryo = require(CollectionViewsParent.Cryo)
local ArgCheck = require(CollectionViewsParent.ArgCheck)
local calculateRelativeColumnGap = require(CollectionViews.Grid.calculateRelativeColumnGap)
local calculateSpacePerItem = require(CollectionViews.calculateSpacePerItem)
local FFlagCollectionViewMathChanges = require(CollectionViewsParent.SharedFlags).FFlagCollectionViewMathChanges
local v9 = game:DefineFastFlag("LuaAppFixCollectionGridWindowAbsoluteCanvasSize", false)
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

local function GridOfCollectionItems(t2: {[any]: any}) -- line: 84
	-- upvalues: Cryo (copy), t1 (copy), React (copy), v9 (copy), ArgCheck (copy), FFlagCollectionViewMathChanges (copy), calculateSpacePerItem (copy), calculateRelativeColumnGap (copy)
	local v13 = Cryo.Dictionary.join(t1, t2)
	local v14 = React.useRef(nil)
	local v15 = math.min(math.ceil(#v13.items / v13.numColumns), v13.maxNumRows)
	local v16 = v13.itemSizeBinding:map(function(vector2: Vector2) -- line: 92
		-- upvalues: v15 (copy), v13 (copy)
		return v15 * (vector2.Y + v13.verticalPadding) - v13.verticalPadding
	end)
	local v17, v18 = React.useState(-1)
	local v19, v20 = React.useState(-1)
	local v21, v22 = React.useState(v13.bufferRowsBelowScreen + v13.bufferRowsAboveScreen)

	React.useEffect(function() -- line: 105
		-- upvalues: v13 (copy), v14 (copy), v15 (copy), v18 (copy), v20 (copy), v22 (copy), v9 (copy)
		local t3 = {}

		if v13.verticalScrollingFrameRef and (v13.verticalScrollingFrameRef.current and v14.current) then
			local current = v14.current
			local current2 = v13.verticalScrollingFrameRef.current
			local Y = v13.itemSizeBinding:getValue().Y
			local AbsolutePositionY = current2.AbsolutePosition.Y
			local AbsoluteWindowSizeY = current2.AbsoluteWindowSize.Y
			local u35 = math.ceil(AbsoluteWindowSizeY / math.max(1, Y + v13.verticalPadding)) + 1

			local function calculateOffsetOfGrid() -- line: 122
				-- upvalues: current (copy), current2 (copy), AbsolutePositionY (ref)
				return current.AbsolutePosition.Y + current2.CanvasPosition.Y - AbsolutePositionY
			end

			local u37 = current.AbsolutePosition.Y + current2.CanvasPosition.Y - AbsolutePositionY

			local function updateRowsToRender() -- line: 129
				-- upvalues: current2 (copy), v13 (copy), v15 (copy), u37 (ref), AbsoluteWindowSizeY (ref), u35 (ref), v18 (copy), v20 (copy)
				local CanvasPositionY = current2.CanvasPosition.Y
				local Y2 = v13.itemSizeBinding:getValue().Y
				local v59 = math.max(1, Y2 + v13.verticalPadding)
				local v60 = v15 * (Y2 + v13.verticalPadding) - v13.verticalPadding
				local v61 = u37 - CanvasPositionY
				local v62 = v13.bufferRowsAboveScreen * v59
				local v63 = v13.bufferRowsBelowScreen * v59
				local n1, n2

				if v61 > AbsoluteWindowSizeY + v63 or v61 + v60 < -v62 then
					n1 = -1
					n2 = -1
				else
					local v66 = math.floor(-v61 / v59)

					n1 = math.max(1, v66 + 1 - v13.bufferRowsAboveScreen)

					local v67 = u35 + v13.bufferRowsBelowScreen
					local v68 = math.max(1, if not (v66 <= 0) then v67 + math.min(v66, v13.bufferRowsAboveScreen) else v67 + v66)

					n2 = math.min(v15, n1 + v68 - 1)
				end

				v18(n1)
				v20(n2)
			end
			local function updateWindowParams() -- line: 174
				-- upvalues: v13 (copy), AbsolutePositionY (ref), current2 (copy), AbsoluteWindowSizeY (ref), u37 (ref), current (copy), u35 (ref), v22 (copy), v15 (copy), updateRowsToRender (copy)
				local v69 = math.max(1, v13.itemSizeBinding:getValue().Y + v13.verticalPadding)

				AbsolutePositionY = current2.AbsolutePosition.Y
				AbsoluteWindowSizeY = current2.AbsoluteWindowSize.Y
				u37 = current.AbsolutePosition.Y + current2.CanvasPosition.Y - AbsolutePositionY
				u35 = math.ceil(AbsoluteWindowSizeY / v69) + 1
				v22((math.min(v15, u35 + v13.bufferRowsBelowScreen + v13.bufferRowsAboveScreen)))
				updateRowsToRender()
			end

			table.insert(t3, current2:GetPropertyChangedSignal("AbsolutePosition"):Connect(updateWindowParams))
			table.insert(t3, current2:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(updateWindowParams))
			table.insert(t3, current2:GetPropertyChangedSignal(not v9 and "CanvasSize" or "AbsoluteCanvasSize"):Connect(updateWindowParams))
			table.insert(t3, current2:GetPropertyChangedSignal("CanvasPosition"):Connect(updateRowsToRender))
			updateWindowParams()
		else
			v18(1)
			v20(v15)
			v22(v15)
		end

		return function() -- line: 221
			-- upvalues: t3 (copy)
			for _, v71 in t3 do
				v71:Disconnect()
			end
		end
	end, {
		v14,
		v15,
		v13.itemSizeBinding,
		v13.verticalScrollingFrameRef,
		v13.verticalPadding,
		v13.bufferRowsAboveScreen,
		v13.bufferRowsBelowScreen,
		v13.onViewableItemsChanged
	})

	local u23 = math.min(v19, v15)
	local v24 = math.max(-1, (v17 - 1) * v13.numColumns + 1)
	local v25 = math.max(-1, (math.min(#v13.items, u23 * v13.numColumns)))

	React.useEffect(function() -- line: 246
		-- upvalues: v13 (copy), v24 (copy), v25 (copy)
		if v13.onViewableItemsChanged then
			v13.onViewableItemsChanged(v24, v25)
		end
	end, {
		v24,
		v25,
		v13.onViewableItemsChanged
	})

	local v26 = React.useRef(nil)

	React.useEffect(function() -- line: 254
		-- upvalues: u23 (ref), v15 (copy), v13 (copy), v26 (copy)
		if u23 >= v15 - v13.thresholdRowsFromBottom and v26.current ~= v13.items and v13.onReachedThresholdFromEnd then
			v13.onReachedThresholdFromEnd()
			v26.current = v13.items
		end
	end, {
		u23,
		v15,
		v13.thresholdRowsFromBottom,
		v13.onReachedThresholdFromEnd,
		v13.items
	})

	local v27 = React.useMemo(function() -- line: 273
		-- upvalues: v17 (copy), u23 (ref), v24 (copy), v25 (copy), v13 (copy), v15 (copy), ArgCheck (copy), React (copy), FFlagCollectionViewMathChanges (copy), calculateSpacePerItem (copy), calculateRelativeColumnGap (copy), v21 (copy)
		local t4 = {}

		if v17 <= 0 or u23 < v17 then
			return nil
		end

		if v24 <= 0 or v25 < v24 then
			return nil
		end

		if v13.numColumns <= 0 or v15 - v17 < 0 then
			return nil
		end

		ArgCheck.assert(v17 >= 1)
		ArgCheck.assert(u23 >= v17 and u23 <= v15)

		if v17 > 1 then
			local v41 = v17 - 1

			t4.Padding = React.createElement("UIPadding", {
				PaddingTop = v13.itemSizeBinding:map(function(vector2: Vector2) -- line: 291
					-- upvalues: v41 (copy), v13 (copy)
					return UDim.new(0, v41 * (vector2.Y + v13.verticalPadding))
				end)
			})
		end

		local v42 = v15 - v17 + 1

		ArgCheck.assert(v42 >= 1)
		ArgCheck.assert(v13.numColumns >= 1)

		local uDim2, uDim2_2

		if FFlagCollectionViewMathChanges then
			local v43 = calculateSpacePerItem(v13.numColumns, v13.columnGap)
			local v44 = calculateSpacePerItem(v42, v13.verticalPadding)

			uDim2 = UDim2.new(1 / v13.numColumns, -v43.gapOffsetPerItem, 1 / v42, -v44.gapOffsetPerItem)
			uDim2_2 = UDim2.new(0, v43.adjustedGap, 0, v44.adjustedGap)
		else
			local v47 = v13.numColumns - 1
			local v48 = v42 - 1

			uDim2 = UDim2.new(1 / v13.numColumns, math.floor(-(v47 / v13.numColumns) * v13.columnGap), 1 / v42, (math.floor(-(v48 / v42) * v13.verticalPadding)))

			local v49 = math.floor(v47 / v13.numColumns * v13.columnGap) * v13.numColumns - v13.columnGap * v47
			local v50 = v13.columnGap + v49 / v47

			uDim2_2 = if not v13.disableRelativeGap then v13.itemSizeBinding:map(function(vector2: Vector2) -- line: 329
				-- upvalues: calculateRelativeColumnGap (copy), v13 (copy)
				local v74 = calculateRelativeColumnGap(v13.numColumns, v13.columnGap, vector2.X, v13.sideMargin)

				return UDim2.new(v74, 0, 0, v13.verticalPadding)
			end) else UDim2.new(0, v50, 0, v13.verticalPadding)
		end

		t4.Layout = React.createElement("UIGridLayout", {
			FillDirectionMaxCells = v13.numColumns,
			CellPadding = uDim2_2,
			CellSize = uDim2,
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			SortOrder = Enum.SortOrder.LayoutOrder
		})
		ArgCheck.assert(v24 >= 1)
		ArgCheck.assert(v25 >= v24 and v25 <= #v13.items)

		for i = v24, v25 do
			if i <= #v13.items then
				local v52 = math.ceil(i / v13.numColumns)
				local v53 = v13.items[i]
				local v54, v55 = v13.renderItem(v53, i, UDim2.fromScale(1, 1), v52)

				t4[`{ v55 }{ i % (v21 * v13.numColumns) }`] = v54
			end
		end

		return t4
	end, {
		v13.columnGap,
		v13.numColumns,
		v13.itemSizeBinding,
		v17,
		u23,
		v13.items,
		v13.renderItem,
		v13.verticalPadding,
		v21,
		v15,
		if FFlagCollectionViewMathChanges then nil else v13.sideMargin,
		v24,
		v25,
		if FFlagCollectionViewMathChanges then nil else v13.disableRelativeGap
	})

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		ref = v14,
		Size = v16:map(function(p1) -- line: 379
			return UDim2.new(1, 0, 0, p1)
		end),
		LayoutOrder = v13.LayoutOrder,
		Position = v13.Position
	}, v27)
end

return React.memo(GridOfCollectionItems)
