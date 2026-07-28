local Parent = script:FindFirstAncestor("BulkPurchaseApp").Parent
local React = require(Parent.React)
local useDesignTokens = require(Parent.Style).useDesignTokens
local Item = require(script.Parent.Item)

local function ItemList_DEPRECATED(t1: {[any]: any}) -- line: 21
	-- upvalues: useDesignTokens (copy), React (copy), Item (copy)
	local v7 = useDesignTokens()
	local t2 = {
		Layout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Bottom,
			Padding = UDim.new(0, v7.Size.Size_300)
		})
	}

	for v9, v10 in t1.items do
		t2[v10.id] = React.createElement(Item, {
			name = v10.name,
			image = v10.image,
			endSlot = v10.endSlot,
			LayoutOrder = v9
		})
	end

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		LayoutOrder = t1.LayoutOrder,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y
	}, t2)
end

return ItemList_DEPRECATED
