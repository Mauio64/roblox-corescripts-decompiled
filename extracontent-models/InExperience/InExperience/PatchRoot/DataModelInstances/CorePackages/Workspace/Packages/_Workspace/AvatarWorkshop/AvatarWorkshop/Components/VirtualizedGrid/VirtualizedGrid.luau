local parent = script:FindFirstAncestor("AvatarWorkshop").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)

local VirtualizedList = require(parent.VirtualizedList)
local FlatList = VirtualizedList.FlatList

local useTokens = Foundation.Hooks.useTokens

local function getItemMetrics(p: number, columnGap: number, p2) -- 1 equivalent call inferred from this helper
	local v = math.floor((p + columnGap) / (p2.minimumItemWidth + columnGap))
	local itemsPerRow = math.max(p2.minimumItemsPerRow, v)
	return {
		itemsPerRow = itemsPerRow,
		itemWidth = math.floor((p - (itemsPerRow - 1) * columnGap) / itemsPerRow)
	}
end

local function chunkIntoRows(data, p: number)
	local result = table.create((math.ceil(math.max(#data, 1) / p)))

	for i = 1, #data, p do
		table.insert(result, { unpack(data, i, (math.min(i + p - 1, #data))) })
	end

	return result
end

local function VirtualizedGrid(props)
	local v = useTokens()

	local minItemWidth = props.minItemWidth
	local minColumns = props.minColumns or 1
	local v2 = props.fallbackNumColumns or 3
	local columnGap = props.columnGap or v.Gap.Small
	local rowGap = props.rowGap or v.Gap.Small

	local contentPaddingTop = props.contentPaddingTop or v.Padding.XSmall
	local contentPaddingBottom = props.contentPaddingBottom
	local v3 = props.ListFooterSlot ~= nil

	local v4 = v.Padding.XSmall * 2
	local keyExtractor = props.keyExtractor

	local state, setState = React.useState(props.lastMeasuredGridWidth or 0)

	local onAbsoluteSizeChanged = React.useCallback(function(p)
		local x = p.AbsoluteSize.X

		if x == 0 then
			return
		end

		setState(x)

		if props.onGridWidthChanged then
			props.onGridWidthChanged(x)
		end
	end, { props.onGridWidthChanged })
	local v5

	if minItemWidth == nil then
		v5 = false
	else
		v5 = state == 0
	end

	if minItemWidth ~= nil and state > 0 then
		v2 = getItemMetrics(state - v4, columnGap, { -- inferred equivalent call
			minimumItemWidth = minItemWidth,
			minimumItemsPerRow = minColumns
		}).itemsPerRow
	end

	local v6 = React.useMemo(function()
		return chunkIntoRows(props.data, v2)
	end, { props.data, v2 })

	local renderItem = React.useCallback(function(p)
		local item = p.item
		local index = p.index
		local v7 = (index - 1) * v2
		local v8 = index == #v6

		local children = {}

		for k, v9 in item do
			local v10 = v7 + k
			local v11

			if keyExtractor then
				v11 = keyExtractor(v9, v10)
			else
				v11 = `Item{v10}`
			end

			children[v11] = React.createElement(Foundation.View, {
				tag = "size-full-0 auto-y",
				LayoutOrder = k
			}, {
				Cell = props.renderItem(v9, v10)
			})
		end

		for i = #item + 1, v2 do
			children[`Filler{i}`] = React.createElement(Foundation.View, {
				tag = "size-full-0",
				LayoutOrder = i
			})
		end

		local createElement = React.createElement
		local view = Foundation.View
		local v9 = {
			tag = "row flex-x-fill size-full-0 auto-y padding-x-xsmall",
			layout = {
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, columnGap)
			},
			padding = 0,
			LayoutOrder = 0
		}
		local top

		if index == 1 then
			top = UDim.new(0, contentPaddingTop)
		else
			top = UDim.new(0, 0)
		end

		local bottom

		if v8 and not v3 and contentPaddingBottom ~= nil then
			bottom = UDim.new(0, contentPaddingBottom)
		else
			bottom = UDim.new(0, rowGap)
		end

		v9.padding = { top = top, bottom = bottom }

		v9.LayoutOrder = index
		return createElement(view, v9, children)
	end, {
		v6,
		v2,
		columnGap,
		rowGap,
		contentPaddingTop,
		contentPaddingBottom,
		v3,
		props.renderItem,
		keyExtractor
	})

	local keyExtractor2 = React.useCallback(function(list, p: number)
		local item = list[1]

		if item == nil or not keyExtractor then
			return `Row{p}`
		end

		return keyExtractor(item, (p - 1) * v2 + 1)
	end, { keyExtractor, v2 })
	local listFooterComponent

	if props.ListFooterSlot then
		listFooterComponent = React.createElement(Foundation.View, {
			tag = "size-full-0 auto-y",
			padding = {
				bottom = UDim.new(0, contentPaddingBottom or v.Padding.Medium)
			}
		}, { Footer = props.ListFooterSlot })
	end

	local createElement = React.createElement
	local view = Foundation.View
	local list

	if not v5 then
		list = React.createElement(FlatList, {
			data = v6,
			renderItem = renderItem,
			keyExtractor = keyExtractor2,
			ListEmptyComponent = props.ListEmptySlot,
			ListHeaderComponent = props.ListHeaderSlot,
			ListFooterComponent = listFooterComponent,
			onEndReached = props.onEndReached,
			onEndReachedThreshold = props.onEndReachedThreshold or 2,
			windowSize = props.windowSize or 10,
			initialNumToRender = props.initialNumToRender or 8,
			maxToRenderPerBatch = props.maxToRenderPerBatch or 1,
			updateCellsBatchingPeriod = props.updateCellsBatchingPeriod or 30,
			contentContainerStyle = { BackgroundTransparency = 1, BorderSizePixel = 0 },
			style = {
				BackgroundTransparency = 1,
				ScrollBarThickness = 0,
				BorderSizePixel = 0,
				ClipsDescendants = false
			}
		})
	end

	return createElement(view, {
		tag = "size-full clip",
		onAbsoluteSizeChanged = onAbsoluteSizeChanged
	}, {
		List = list
	})
end

return VirtualizedGrid
