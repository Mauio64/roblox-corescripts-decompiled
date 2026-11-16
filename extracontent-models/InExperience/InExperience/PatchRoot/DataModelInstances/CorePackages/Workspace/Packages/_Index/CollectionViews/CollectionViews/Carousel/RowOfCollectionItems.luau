local parent = script:FindFirstAncestor("CollectionViews").Parent
local React = require(parent.React)
local ArgCheck = require(parent.ArgCheck)

local function RowOfCollectionItems(props)
	local v = React.useMemo(function()
		if props.numToRender == 0 or props.numItemsForSizing == 0 then
			return nil
		end

		local v = props.startingIndex - 1

		local numItemsForSizing = props.numItemsForSizing
		local v2 = numItemsForSizing - 1

		local v3 = math.floor(v2 / numItemsForSizing * props.columnGap)
		local udim = UDim2.new(1 / numItemsForSizing, -v3, 1, 0)

		local v4 = v3 * numItemsForSizing - props.columnGap * v2
		local v5 = props.columnGap + v4 / v2
		local children = {}

		children.Layout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Horizontal,
			Padding = UDim.new(0, v5),
			HorizontalAlignment = Enum.HorizontalAlignment.Left
		})

		if v > 0 then
			children.Padding = React.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(v * udim.X.Scale, (v - 1) * v5 + v * udim.X.Offset, 0, 0),
				LayoutOrder = 0
			})
		end

		ArgCheck.assert(props.startingIndex >= 1 and props.startingIndex <= #props.items)
		ArgCheck.assert(props.endingIndex >= props.startingIndex and props.endingIndex <= #props.items)

		for i = props.startingIndex, props.endingIndex do
			if not (i >= 1 and i <= #props.items) then
				continue
			end

			local item = props.items[i]
			local item2, v6 = props.renderItem(item, i, udim)
			children[v6 .. tostring(i % props.numToRender + 1)] = item2
		end

		return children
	end, {
		props.columnGap,
		props.startingIndex,
		props.endingIndex,
		props.items,
		props.numToRender,
		props.renderItem,
		props.sideMargin,
		props.totalItemsOnCanvas,
		props.numItemsForSizing
	})

	return React.createElement(React.Fragment, nil, v)
end

return React.memo(RowOfCollectionItems)
