local BulkPurchaseApp = script:FindFirstAncestor("BulkPurchaseApp")
local parent = BulkPurchaseApp.Parent
local React = require(parent.React)
local UIBlox = require(parent.UIBlox)
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel

local Price_DEPRECATED = require(BulkPurchaseApp.Components.Price_DEPRECATED)
local ItemStatus = require(BulkPurchaseApp.Components.ItemStatus)
local ItemPresentationMapperDEPRECATED = {}

function ItemPresentationMapperDEPRECATED.mapItemsToPresentation_DEPRECATED(items, fontStyle, colorStyle)
	local result = {}

	for _, item in items do
		table.insert(result, {
			id = item.id,
			name = item.name,
			image = item.image,
			endSlot = React.createElement(Price_DEPRECATED, {
				amount = item.cost,
				fontStyle = fontStyle,
				colorStyle = colorStyle
			})
		})
	end

	return result
end

function ItemPresentationMapperDEPRECATED.mapOwnedItemsToPresentation_DEPRECATED(items, fontStyle, colorStyle, p)
	local result = {}

	for _, item in items do
		table.insert(result, {
			id = item.id,
			name = item.name,
			image = item.image,
			endSlot = React.createElement(StyledTextLabel, {
				fontStyle = fontStyle,
				colorStyle = colorStyle,
				textXAlignment = Enum.TextXAlignment.Right,
				textYAlignment = Enum.TextYAlignment.Top,
				lineHeight = fontStyle.LineHeight,
				size = UDim2.fromScale(1, 1),
				text = p.itemOwned:gsub("{.*}", (tostring(item.ownedCount)))
			})
		})
	end

	return result
end

function ItemPresentationMapperDEPRECATED.mapUnpurchasableItemsToPresentation_DEPRECATED(items)
	local result = {}

	for _, item in items do
		table.insert(result, {
			id = item.id,
			name = item.name,
			image = item.image,
			endSlot = React.createElement(ItemStatus, { status = item.status })
		})
	end

	return result
end

return ItemPresentationMapperDEPRECATED
