local React = require("@game/CorePackages/Workspace/Packages/_Workspace/CollectionViews/React")
local ArgCheck = require("@game/CorePackages/Workspace/Packages/_Index/CollectionViews/ArgCheck")

local function RowOfCollectionItems(props)
	local v5 = React.useMemo(function()
		if props.numToRender == 0 or props.numItemsForSizing == 0 then
			return nil
		end

		local v6 = props.startingIndex - 1

		local numItemsForSizing = props.numItemsForSizing
		local v7 = numItemsForSizing - 1

		local v8 = math.floor(v7 / numItemsForSizing * props.columnGap)
		local udim = UDim2.new(1 / numItemsForSizing, -v8, 1, 0)

		local v9 = v8 * numItemsForSizing - props.columnGap * v7
		local v10 = props.columnGap + v9 / v7
		local children = {}

		children.Layout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Horizontal,
			Padding = UDim.new(0, v10),
			HorizontalAlignment = Enum.HorizontalAlignment.Left
		})

		if v6 > 0 then
			children.Padding = React.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(v6 * udim.X.Scale, (v6 - 1) * v10 + v6 * udim.X.Offset, 0, 0),
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
			local item2, v13 = props.renderItem(item, i, udim)
			children[v13 .. tostring(i % props.numToRender + 1)] = item2
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

	return React.createElement(React.Fragment, nil, v5)
end

return React.memo(RowOfCollectionItems)
