local Parent = script:FindFirstAncestor("BulkPurchaseApp").Parent
local React = require(Parent.React)
local FFlagRenameDeprecatedUIBloxTokens = require(Parent.SharedFlags).FFlagRenameDeprecatedUIBloxTokens
local useDesignTokens = require(Parent.Style).useDesignTokens
local Item = require(script.Parent.Item)

local function ItemList_DEPRECATED(t1: {[any]: any}) -- line: 23
	-- upvalues: useDesignTokens (copy), React (copy), FFlagRenameDeprecatedUIBloxTokens (copy), Item (copy)
	local v8 = useDesignTokens()
	local t2 = {
		Layout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Bottom,
			Padding = UDim.new(0, if not FFlagRenameDeprecatedUIBloxTokens then v8.Global.Space_150 else v8.Size.Size_300)
		})
	}

	for v10, v11 in t1.items do
		t2[v11.id] = React.createElement(Item, {
			name = v11.name,
			image = v11.image,
			endSlot = v11.endSlot,
			LayoutOrder = v10
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
