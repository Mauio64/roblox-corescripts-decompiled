local parent = script:FindFirstAncestor("BulkPurchaseApp").Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local AvatarExperienceCommon = require(parent.AvatarExperienceCommon)
local CatalogRowItemCard = AvatarExperienceCommon.Components.CatalogItemCard.CatalogRowItemCard

local function ItemList(p)
	local v = useTokens()
	local children = {
		Layout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Bottom,
			Padding = UDim.new(0, v.Gap.Medium)
		})
	}

	local size_1200 = v.Size.Size_1200

	for k, item in p.items do
		local v2 = {
			LayoutOrder = k,
			title = item.title,
			presentationSlot = item.presentationSlot,
			priceLineContent = item.priceLineContent,
			headerSize = UDim2.fromOffset(size_1200, size_1200),
			footerSize = UDim2.new(1, 0, 1, 0),
			AutomaticSize = Enum.AutomaticSize.XY
		}

		children[item.id] = React.createElement(CatalogRowItemCard, v2)
	end

	return React.createElement("Frame", {
		LayoutOrder = p.LayoutOrder,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		BorderSizePixel = 0
	}, children)
end

return ItemList
