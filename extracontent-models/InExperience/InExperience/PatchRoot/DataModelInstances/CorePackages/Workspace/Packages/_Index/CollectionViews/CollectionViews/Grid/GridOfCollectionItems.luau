local CollectionViews = script:FindFirstAncestor("CollectionViews")
local parent = CollectionViews.Parent
local React = require(parent.React)
local Cryo = require(parent.Cryo)
local ArgCheck = require(parent.ArgCheck)
local calculateRelativeColumnGap = require(CollectionViews.Grid.calculateRelativeColumnGap)

local defineFastFlag = game:DefineFastFlag("LuaAppFixCollectionGridWindowAbsoluteCanvasSize", false)
local defineFastFlag2 = game:DefineFastFlag("LuaAppGridReuseUnchangedTileElements", false)

local v = {
	maxNumRows = 1e999,
	numColumns = 1,
	bufferRowsBelowScreen = 4,
	bufferRowsAboveScreen = 4,
	columnGap = 0,
	sideMargin = 0,
	verticalPadding = 0,
	thresholdRowsFromBottom = 0
}

local function GridOfCollectionItems(p)
	local joined = Cryo.Dictionary.join(v, p)
	local ref = React.useRef(nil)

	local v2 = math.min(math.ceil(#joined.items / joined.numColumns), joined.maxNumRows)

	local mapped = joined.itemSizeBinding:map(function(vector2: Vector2)
		return v2 * (vector2.Y + joined.verticalPadding) - joined.verticalPadding
	end)

	local state, setState = React.useState(-1)
	local state2, setState2 = React.useState(-1)

	local state3, setState3 = React.useState(joined.bufferRowsBelowScreen + joined.bufferRowsAboveScreen)

	React.useEffect(function()
		local connections = {}

		if joined.verticalScrollingFrameRef and joined.verticalScrollingFrameRef.current and ref.current then
			local current = ref.current
			local current2 = joined.verticalScrollingFrameRef.current
			local y = joined.itemSizeBinding:getValue().Y

			local y2 = current2.AbsolutePosition.Y

			local y3 = current2.AbsoluteWindowSize.Y

			local v3 = math.ceil(y3 / math.max(1, y + joined.verticalPadding)) + 1

			local function calculateOffsetOfGrid() -- 1 equivalent call inferred from this helper
				return current.AbsolutePosition.Y + current2.CanvasPosition.Y - y2
			end
			local v4 = current.AbsolutePosition.Y + current2.CanvasPosition.Y - y2

			local function updateRowsToRender()
				local y4 = current2.CanvasPosition.Y
				local y5 = joined.itemSizeBinding:getValue().Y
				local v5 = math.max(1, y5 + joined.verticalPadding)
				local v6 = v2 * (y5 + joined.verticalPadding) - joined.verticalPadding

				local v7 = v4 - y4

				local v8 = joined.bufferRowsAboveScreen * v5
				local v9 = joined.bufferRowsBelowScreen * v5
				local v10, v11

				if y3 + v9 < v7 or v7 + v6 < -v8 then
					v10 = -1
					v11 = -1
				else
					local v12 = math.floor(-v7 / v5)

					v10 = math.max(1, v12 + 1 - joined.bufferRowsAboveScreen)

					local v13 = v3 + joined.bufferRowsBelowScreen
					local v14

					if v12 <= 0 then
						v14 = v13 + v12
					else
						v14 = v13 + math.min(v12, joined.bufferRowsAboveScreen)
					end

					v11 = math.min(v2, v10 + math.max(1, v14) - 1)
				end

				setState(v10)
				setState2(v11)
			end

			local function updateWindowParams()
				local v5 = math.max(1, joined.itemSizeBinding:getValue().Y + joined.verticalPadding)
				y2 = current2.AbsolutePosition.Y
				y3 = current2.AbsoluteWindowSize.Y
				v4 = calculateOffsetOfGrid() -- inferred equivalent call
				v3 = math.ceil(y3 / v5) + 1
				setState3((math.min(v2, v3 + joined.bufferRowsBelowScreen + joined.bufferRowsAboveScreen)))

				updateRowsToRender()
			end

			table.insert(connections, current2:GetPropertyChangedSignal("AbsolutePosition"):Connect(updateWindowParams))

			table.insert(
				connections,
				current2:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(updateWindowParams)
			)

			table.insert(
				connections,
				current2:GetPropertyChangedSignal(defineFastFlag and "AbsoluteCanvasSize" or "CanvasSize"):Connect(updateWindowParams)
			)

			table.insert(connections, current2:GetPropertyChangedSignal("CanvasPosition"):Connect(updateRowsToRender))

			updateWindowParams()
		else
			setState(1)
			setState2(v2)
			setState3(v2)
		end

		return function()
			for _, connection in connections do
				connection:Disconnect()
			end
		end
	end, {
		ref,
		v2,
		joined.itemSizeBinding,
		joined.verticalScrollingFrameRef,
		joined.verticalPadding,
		joined.bufferRowsAboveScreen,
		joined.bufferRowsBelowScreen,
		joined.onViewableItemsChanged
	})

	local v3 = math.min(state2, v2)

	local v4 = math.max(-1, (state - 1) * joined.numColumns + 1)
	local v5 = math.max(-1, (math.min(#joined.items, v3 * joined.numColumns)))

	React.useEffect(function()
		if joined.onViewableItemsChanged then
			joined.onViewableItemsChanged(v4, v5)
		end
	end, { v4, v5, joined.onViewableItemsChanged })

	local ref2 = React.useRef(nil)
	React.useEffect(function()
		if
			v3 >= v2 - joined.thresholdRowsFromBottom
			and ref2.current ~= joined.items
			and joined.onReachedThresholdFromEnd
		then
			joined.onReachedThresholdFromEnd()
			ref2.current = joined.items
		end
	end, { v3, v2, joined.thresholdRowsFromBottom, joined.onReachedThresholdFromEnd, joined.items })
	local ref3

	if defineFastFlag2 then
		ref3 = React.useRef({})
	else
		ref3 = nil
	end

	local v6 = React.useMemo(function()
		local children = {}

		if state <= 0 or v3 < state or (v4 <= 0 or v5 < v4) then
			return nil
		end

		if joined.numColumns <= 0 or v2 - state < 0 then
			return nil
		end

		ArgCheck.assert(state >= 1)
		ArgCheck.assert(state <= v3 and v3 <= v2)

		if state > 1 then
			local v6 = state - 1
			children.Padding = React.createElement("UIPadding", {
				PaddingTop = joined.itemSizeBinding:map(function(vector2: Vector2)
					return UDim.new(0, v6 * (vector2.Y + joined.verticalPadding))
				end)
			})
		end

		local v6 = v2 - state + 1

		ArgCheck.assert(v6 >= 1)
		ArgCheck.assert(joined.numColumns >= 1)

		local v7 = joined.numColumns - 1
		local v8 = v6 - 1
		local udim = UDim2.new(
			1 / joined.numColumns,
			math.floor(-(v7 / joined.numColumns) * joined.columnGap),
			1 / v6,
			(math.floor(-(v8 / v6) * joined.verticalPadding))
		)

		local v9 = math.floor(v7 / joined.numColumns * joined.columnGap) * joined.numColumns - joined.columnGap * v7
		local v10 = joined.columnGap + v9 / v7
		local cellPadding

		if joined.disableRelativeGap then
			cellPadding = UDim2.new(0, v10, 0, joined.verticalPadding)
		else
			cellPadding = joined.itemSizeBinding:map(function(vector2: Vector2)
				local v11 = calculateRelativeColumnGap(
					joined.numColumns,
					joined.columnGap,
					vector2.X,
					joined.sideMargin
				)
				return UDim2.new(v11, 0, 0, joined.verticalPadding)
			end)
		end

		children.Layout = React.createElement("UIGridLayout", {
			FillDirectionMaxCells = joined.numColumns,
			CellPadding = cellPadding,
			CellSize = udim,
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			SortOrder = Enum.SortOrder.LayoutOrder
		})

		ArgCheck.assert(v4 >= 1)
		ArgCheck.assert(v4 <= v5 and v5 <= #joined.items)

		if defineFastFlag2 then
			local current = ref3.current
			local current2 = {}

			for i = v4, v5 do
				if not (i <= #joined.items) then
					continue
				end

				local rowNum = math.ceil(i / joined.numColumns)
				local item = joined.items[i]
				local v11 = current[i]
				local element, keyPrefix

				if v11 and v11.entry == item and v11.renderItem == joined.renderItem and v11.rowNum == rowNum then
					element = v11.element
					keyPrefix = v11.keyPrefix
				else
					element, keyPrefix = joined.renderItem(item, i, UDim2.fromScale(1, 1), rowNum)
				end

				current2[i] = {
					entry = item,
					renderItem = joined.renderItem,
					rowNum = rowNum,
					element = element,
					keyPrefix = keyPrefix
				}

				children[`{keyPrefix}{i % (state3 * joined.numColumns)}`] = element
			end

			ref3.current = current2
			return children
		end

		for i = v4, v5 do
			if not (i <= #joined.items) then
				continue
			end

			local v11 = math.ceil(i / joined.numColumns)
			local item = joined.items[i]
			local item2, v12 = joined.renderItem(item, i, UDim2.fromScale(1, 1), v11)
			children[`{v12}{i % (state3 * joined.numColumns)}`] = item2
		end

		return children
	end, {
		joined.columnGap,
		joined.numColumns,
		joined.itemSizeBinding,
		state,
		v3,
		joined.items,
		joined.renderItem,
		joined.verticalPadding,
		state3,
		v2,
		joined.sideMargin,
		v4,
		v5,
		joined.disableRelativeGap
	})

	return React.createElement("Frame", {
		ref = ref,
		Size = mapped:map(function(p2)
			return UDim2.new(1, 0, 0, p2)
		end),
		BackgroundTransparency = 1,
		LayoutOrder = joined.LayoutOrder,
		Position = joined.Position
	}, v6)
end

return React.memo(GridOfCollectionItems)
