local BulkPurchaseApp = script:FindFirstAncestor("BulkPurchaseApp")

require(BulkPurchaseApp.Store.Types)
local PurchasableStateEnum = require(BulkPurchaseApp.Enums.PurchasableStateEnum)
local createPurchasableItem = require(script.Parent.createPurchasableItem)
local createOwnedItem = require(script.Parent.createOwnedItem)
local createUnpurchasableItem = require(script.Parent.createUnpurchasableItem)

local FFlagAXAddPlusUpsellToBulkPurchase = require(BulkPurchaseApp.Flags.FFlagAXAddPlusUpsellToBulkPurchase)
local FFlagAXAddOffersToBulkPurchase = require(BulkPurchaseApp.Flags.FFlagAXAddOffersToBulkPurchase)

local function selectBulkPurchaseRequestState(data)
	local items = {}
	local ownedItems = {}
	local unpurchasableItems = {}

	if data.itemData then
		for _, v in data.itemData do
			if v.purchasableState == PurchasableStateEnum.Purchasable then
				table.insert(items, createPurchasableItem(v))

				if v.ownedCount and v.ownedCount > 0 then
					table.insert(ownedItems, createOwnedItem(v))
				end
			else
				table.insert(unpurchasableItems, createUnpurchasableItem(v))
			end
		end
	end

	local bulkPurchaseRequestState = {
		totalCost = data.totalCost or 0,
		items = items,
		ownedItems = ownedItems,
		unpurchasableItems = unpurchasableItems,
		balance = data.balance or 0,
		discountInformation = data.discountInformation,
		offerData = 0,
		disablePurchase = 0
	}
	local offerData

	if FFlagAXAddOffersToBulkPurchase then
		offerData = data.offerData
	end

	bulkPurchaseRequestState.offerData = offerData
	local disablePurchase

	if FFlagAXAddPlusUpsellToBulkPurchase then
		disablePurchase = data.disablePurchase
	end

	bulkPurchaseRequestState.disablePurchase = disablePurchase
	return bulkPurchaseRequestState
end

return selectBulkPurchaseRequestState
