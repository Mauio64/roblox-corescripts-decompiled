local Parent = script:FindFirstAncestor("ItemDetails").Parent
local React = require(Parent.React)
local ItemInfoRow = require(script.Parent.ItemInfoRow)
local Cryo = require(Parent.Cryo)

local function ItemInfoList(t1: {[any]: any}) -- line: 42
	-- upvalues: React (copy), Cryo (copy), ItemInfoRow (copy)
	local t2 = {
		layout = React.createElement("UIListLayout", {
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical
		})
	}

	for v8, v9 in t1.rowData do
		local v10 = Cryo.Dictionary.join(v9, {
			LayoutOrder = v8,
			hideDivider = next(t1.rowData, v8) == nil
		})

		table.insert(t2, React.createElement(ItemInfoRow, v10))
	end

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.fromScale(1, 0),
		LayoutOrder = t1.LayoutOrder
	}, t2)
end

return ItemInfoList
