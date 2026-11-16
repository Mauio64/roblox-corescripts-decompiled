local parent = script:FindFirstAncestor("ItemDetails").Parent

local React = require(parent.React)
local ItemInfoRow = require(script.Parent.ItemInfoRow)
local Cryo = require(parent.Cryo)

local function ItemInfoList(p)
	local children = {
		layout = React.createElement("UIListLayout", {
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical
		})
	}

	for k, v in p.rowData do
		local joined = Cryo.Dictionary.join(v, {
			LayoutOrder = k,
			hideDivider = next(p.rowData, k) == nil
		})

		table.insert(children, React.createElement(ItemInfoRow, joined))
	end

	return React.createElement(
		"Frame",
		{
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.fromScale(1, 0),
			BackgroundTransparency = 1,
			LayoutOrder = p.LayoutOrder
		},
		children
	)
end

return ItemInfoList
