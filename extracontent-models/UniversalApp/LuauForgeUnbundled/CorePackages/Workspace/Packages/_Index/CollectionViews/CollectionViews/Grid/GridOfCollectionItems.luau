local React = require("@game/CorePackages/Workspace/Packages/_Workspace/CollectionViews/React")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/CollectionViews/Cryo")
local ArgCheck = require("@game/CorePackages/Workspace/Packages/_Index/CollectionViews/ArgCheck")
local calculateRelativeColumnGap = require("@game/CorePackages/Workspace/Packages/_Index/CollectionViews/CollectionViews/Grid/calculateRelativeColumnGap")

local defineFastFlag = game:DefineFastFlag("LuaAppFixCollectionGridWindowAbsoluteCanvasSize", false)
local defineFastFlag2 = game:DefineFastFlag("LuaAppGridReuseUnchangedTileElements", false)

local v5 = {
	maxNumRows = 1e999,
	numColumns = 1,
	bufferRowsBelowScreen = 4,
	bufferRowsAboveScreen = 4,
	columnGap = 0,
	sideMargin = 0,
	verticalPadding = 0,
	thresholdRowsFromBottom = 0
}

local function GridOfCollectionItems(p2)
	local joined = Cryo.Dictionary.join(v5, p2)
	local ref = React.useRef(nil)

	local v6 = math.min(math.ceil(#joined.items / joined.numColumns), joined.maxNumRows)

	local mapped = joined.itemSizeBinding:map(function(p3)
		return v6 * (p3.Y + joined.verticalPadding) - joined.verticalPadding
	end)

	local state, setState = React.useState(-1)
	local state2, setState2 = React.useState(-1)

	local state3, setState3 = React.useState(joined.bufferRowsBelowScreen + joined.bufferRowsAboveScreen)

	React.useEffect(function()
		local connections = {}

		if
			joined.verticalScrollingFrameRef
			and joined.verticalScrollingFrameRef.current
			and ref.current
		then
			local current = ref.current
			local current2 = joined.verticalScrollingFrameRef.current
			local y = joined.itemSizeBinding:getValue().Y

			local y2 = current2.AbsolutePosition.Y

			local y3 = current2.AbsoluteWindowSize.Y

			local v7 = math.ceil(y3 / math.max(1, y + joined.verticalPadding)) + 1

			local function calculateOffsetOfGrid()
				return current.AbsolutePosition.Y + current2.CanvasPosition.Y - y2
			end
			local v8 = current.AbsolutePosition.Y + current2.CanvasPosition.Y - y2

			local function updateRowsToRender()
				local y4 = current2.CanvasPosition.Y
				local y5 = joined.itemSizeBinding:getValue().Y
				local v9 = math.max(1, y5 + joined.verticalPadding)
				local v10 = v6 * (y5 + joined.verticalPadding) - joined.verticalPadding

				local v11 = v8 - y4

				local v12 = joined.bufferRowsAboveScreen * v9
				local v13 = joined.bufferRowsBelowScreen * v9
				local v14, v15

				if y3 + v13 < v11 or v11 + v10 < -v12 then
					v14 = -1
					v15 = -1
				else
					local v16 = math.floor(-v11 / v9)

					v14 = math.max(1, v16 + 1 - joined.bufferRowsAboveScreen)

					local v17 = v7 + joined.bufferRowsBelowScreen
					local v18 = if v16 <= 0 then v17 + v16 else v17 + math.min(v16, joined.bufferRowsAboveScreen)

					local v19 = math.max(1, v18)
					v15 = math.min(v6, v14 + v19 - 1)
				end

				setState(v14)
				setState2(v15)
			end

			local function updateWindowParams()
				local v9 = math.max(1, joined.itemSizeBinding:getValue().Y + joined.verticalPadding)
				y2 = current2.AbsolutePosition.Y
				y3 = current2.AbsoluteWindowSize.Y
				v8 = current.AbsolutePosition.Y + current2.CanvasPosition.Y - y2
				v7 = math.ceil(y3 / v9) + 1
				setState3((math.min(v6, v7 + joined.bufferRowsBelowScreen + joined.bufferRowsAboveScreen)))

				updateRowsToRender()
			end

			table.insert(
				connections,
				current2:GetPropertyChangedSignal("AbsolutePosition"):Connect(updateWindowParams)
			)

			table.insert(
				connections,
				current2:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(updateWindowParams)
			)

			table.insert(
				connections,
				current2:GetPropertyChangedSignal(defineFastFlag and "AbsoluteCanvasSize" or "CanvasSize"):Connect(updateWindowParams)
			)

			table.insert(
				connections,
				current2:GetPropertyChangedSignal("CanvasPosition"):Connect(updateRowsToRender)
			)

			updateWindowParams()
		else
			setState(1)
			setState2(v6)
			setState3(v6)
		end

		return function()
			for k, connection in connections do
				connection:Disconnect()
			end
		end
	end, {
		ref,
		v6,
		joined.itemSizeBinding,
		joined.verticalScrollingFrameRef,
		joined.verticalPadding,
		joined.bufferRowsAboveScreen,
		joined.bufferRowsBelowScreen,
		joined.onViewableItemsChanged
	})

	local v7 = math.min(state2, v6)

	local v8 = math.max(-1, (state - 1) * joined.numColumns + 1)
	local v9 = math.max(-1, (math.min(#joined.items, v7 * joined.numColumns)))

	React.useEffect(function()
		if joined.onViewableItemsChanged then
			joined.onViewableItemsChanged(v8, v9)
		end
	end, { v8, v9, joined.onViewableItemsChanged })

	local ref2 = React.useRef(nil)
	React.useEffect(function()
		if
			v7 >= v6 - joined.thresholdRowsFromBottom
			and ref2.current ~= joined.items
			and joined.onReachedThresholdFromEnd
		then
			joined.onReachedThresholdFromEnd()
			ref2.current = joined.items
		end
	end, {
		v7,
		v6,
		joined.thresholdRowsFromBottom,
		joined.onReachedThresholdFromEnd,
		joined.items
	})

	local ref3 = if defineFastFlag2 then React.useRef({}) else nil

	local v10 = React.useMemo(function()
		local children = {}

		if state <= 0 or v7 < state or (v8 <= 0 or v9 < v8) then
			return nil
		end

		if joined.numColumns <= 0 or v6 - state < 0 then
			return nil
		end

		ArgCheck.assert(state >= 1)
		ArgCheck.assert(state <= v7 and v7 <= v6)

		if state > 1 then
			local v12 = state - 1
			children.Padding = React.createElement("UIPadding", {
				PaddingTop = joined.itemSizeBinding:map(function(p3)
					return UDim.new(0, v12 * (p3.Y + joined.verticalPadding))
				end)
			})
		end

		local v12 = v6 - state + 1

		ArgCheck.assert(v12 >= 1)
		ArgCheck.assert(joined.numColumns >= 1)

		local v13 = joined.numColumns - 1
		local v14 = v12 - 1
		local udim = UDim2.new(
			1 / joined.numColumns,
			math.floor(-(v13 / joined.numColumns) * joined.columnGap),
			1 / v12,
			(math.floor(-(v14 / v12) * joined.verticalPadding))
		)

		local v15 = math.floor(v13 / joined.numColumns * joined.columnGap) * joined.numColumns - joined.columnGap * v13
		local v16 = joined.columnGap + v15 / v13
		local v17

		if joined.disableRelativeGap then
			v17 = UDim2.new(0, v16, 0, joined.verticalPadding)
		else
			v17 = joined.itemSizeBinding:map(function(p3)
				local v18 = calculateRelativeColumnGap(joined.numColumns, joined.columnGap, p3.X, joined.sideMargin)
				return UDim2.new(v18, 0, 0, joined.verticalPadding)
			end)
		end

		children.Layout = React.createElement("UIGridLayout", {
			FillDirectionMaxCells = joined.numColumns,
			CellPadding = v17,
			CellSize = udim,
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			SortOrder = Enum.SortOrder.LayoutOrder
		})

		ArgCheck.assert(v8 >= 1)
		ArgCheck.assert(v8 <= v9 and v9 <= #joined.items)

		if defineFastFlag2 then
			local current = ref3.current
			local v19 = {}

			for i = v8, v9 do
				if not (i <= #joined.items) then
					continue
				end

				local v20 = math.ceil(i / joined.numColumns)
				local item = joined.items[i]
				local v21 = current[i]
				local v22, v23

				if
					v21
					and v21.entry == item
					and v21.renderItem == joined.renderItem
					and v21.rowNum == v20
				then
					v22 = v21.element
					v23 = v21.keyPrefix
				else
					v22, v23 = joined.renderItem(item, i, UDim2.fromScale(1, 1), v20)
				end

				v19[i] = {
					entry = item,
					renderItem = joined.renderItem,
					rowNum = v20,
					element = v22,
					keyPrefix = v23
				}

				children[`{v23}{i % (state3 * joined.numColumns)}`] = v22
			end

			ref3.current = v19
			return children
		end

		for i = v8, v9 do
			if not (i <= #joined.items) then
				continue
			end

			local v19 = math.ceil(i / joined.numColumns)
			local item = joined.items[i]
			local item2, v20 = joined.renderItem(item, i, UDim2.fromScale(1, 1), v19)
			children[`{v20}{i % (state3 * joined.numColumns)}`] = item2
		end

		return children
	end, {
		joined.columnGap,
		joined.numColumns,
		joined.itemSizeBinding,
		state,
		v7,
		joined.items,
		joined.renderItem,
		joined.verticalPadding,
		state3,
		v6,
		joined.sideMargin,
		v8,
		v9,
		joined.disableRelativeGap
	})

	return React.createElement("Frame", {
		ref = ref,
		Size = mapped:map(function(p3)
			return UDim2.new(1, 0, 0, p3)
		end),
		BackgroundTransparency = 1,
		LayoutOrder = joined.LayoutOrder,
		Position = joined.Position
	}, v10)
end

return React.memo(GridOfCollectionItems)
