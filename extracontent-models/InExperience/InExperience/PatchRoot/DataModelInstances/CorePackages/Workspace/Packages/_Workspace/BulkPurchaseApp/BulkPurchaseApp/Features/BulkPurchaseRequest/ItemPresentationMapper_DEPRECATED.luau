local BulkPurchaseApp = script:FindFirstAncestor("BulkPurchaseApp")
local BulkPurchaseAppParent = BulkPurchaseApp.Parent
local React = require(BulkPurchaseAppParent.React)
local StyledTextLabel = require(BulkPurchaseAppParent.UIBlox).App.Text.StyledTextLabel
local Price_DEPRECATED = require(BulkPurchaseApp.Components.Price_DEPRECATED)
local ItemStatus = require(BulkPurchaseApp.Components.ItemStatus)

return {
	mapItemsToPresentation_DEPRECATED = function(p1, p2, p3) -- line: 10
		-- upvalues: React (copy), Price_DEPRECATED (copy)
		local t1 = {}

		for _, v12 in p1 do
			table.insert(t1, {
				id = v12.id,
				name = v12.name,
				image = v12.image,
				endSlot = React.createElement(Price_DEPRECATED, {
					amount = v12.cost,
					fontStyle = p2,
					colorStyle = p3
				})
			})
		end

		return t1
	end,
	mapOwnedItemsToPresentation_DEPRECATED = function(p4, p5, p6, p7) -- line: 26
		-- upvalues: React (copy), StyledTextLabel (copy)
		local t2 = {}

		for _, v19 in p4 do
			table.insert(t2, {
				id = v19.id,
				name = v19.name,
				image = v19.image,
				endSlot = React.createElement(StyledTextLabel, {
					fontStyle = p5,
					colorStyle = p6,
					textXAlignment = Enum.TextXAlignment.Right,
					textYAlignment = Enum.TextYAlignment.Top,
					lineHeight = p5.LineHeight,
					size = UDim2.fromScale(1, 1),
					text = p7.itemOwned:gsub("{.*}", (tostring(v19.ownedCount)))
				})
			})
		end

		return t2
	end,
	mapUnpurchasableItemsToPresentation_DEPRECATED = function(p8) -- line: 47
		-- upvalues: React (copy), ItemStatus (copy)
		local t3 = {}

		for _, v23 in p8 do
			table.insert(t3, {
				id = v23.id,
				name = v23.name,
				image = v23.image,
				endSlot = React.createElement(ItemStatus, {
					status = v23.status
				})
			})
		end

		return t3
	end
}
