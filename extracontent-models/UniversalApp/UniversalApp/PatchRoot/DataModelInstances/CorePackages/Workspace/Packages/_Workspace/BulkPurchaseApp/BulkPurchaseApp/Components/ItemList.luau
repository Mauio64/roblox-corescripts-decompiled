local Parent = script:FindFirstAncestor("BulkPurchaseApp").Parent
local React = require(Parent.React)
local useTokens = require(Parent.Foundation).Hooks.useTokens
local CatalogRowItemCard = require(Parent.AvatarExperienceCommon).Components.CatalogItemCard.CatalogRowItemCard

local function ItemList(t1: {[any]: any}) -- line: 17
	-- upvalues: useTokens (copy), React (copy), CatalogRowItemCard (copy)
	local v7 = useTokens()
	local t2 = {
		Layout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Bottom,
			Padding = UDim.new(0, v7.Gap.Medium)
		})
	}
	local Size_1200 = v7.Size.Size_1200

	for v10, v11 in t1.items do
		local t3 = {
			LayoutOrder = v10,
			title = v11.title,
			presentationSlot = v11.presentationSlot,
			priceLineContent = v11.priceLineContent,
			headerSize = UDim2.fromOffset(Size_1200, Size_1200),
			footerSize = UDim2.new(1, 0, 1, 0),
			AutomaticSize = Enum.AutomaticSize.XY
		}

		t2[v11.id] = React.createElement(CatalogRowItemCard, t3)
	end

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		LayoutOrder = t1.LayoutOrder,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y
	}, t2)
end

return ItemList
