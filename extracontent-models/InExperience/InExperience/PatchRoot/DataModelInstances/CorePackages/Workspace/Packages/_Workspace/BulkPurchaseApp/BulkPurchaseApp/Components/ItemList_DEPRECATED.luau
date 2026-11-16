local parent = script:FindFirstAncestor("BulkPurchaseApp").Parent
local React = require(parent.React)

local Style = require(parent.Style)
local useDesignTokens = Style.useDesignTokens

local Item = require(script.Parent.Item)

local function ItemList_DEPRECATED(p)
	local v = useDesignTokens()

	local children = {
		Layout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Bottom,
			Padding = UDim.new(0, v.Size.Size_300)
		})
	}

	for k, item in p.items do
		children[item.id] = React.createElement(Item, {
			name = item.name,
			image = item.image,
			endSlot = item.endSlot,
			LayoutOrder = k
		})
	end

	return React.createElement("Frame", {
		LayoutOrder = p.LayoutOrder,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		BorderSizePixel = 0
	}, children)
end

return ItemList_DEPRECATED
