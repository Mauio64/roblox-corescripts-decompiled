local BulkPurchaseApp = script:FindFirstAncestor("BulkPurchaseApp")

require(BulkPurchaseApp.Store.Types)

local PurchasableStateEnum = require(BulkPurchaseApp.Enums.PurchasableStateEnum)
local createPurchasableItem = require(script.Parent.createPurchasableItem)
local createOwnedItem = require(script.Parent.createOwnedItem)
local createUnpurchasableItem = require(script.Parent.createUnpurchasableItem)

local function selectBulkPurchaseRequestState(p1) -- line: 11
	-- upvalues: PurchasableStateEnum (copy), createPurchasableItem (copy), createOwnedItem (copy), createUnpurchasableItem (copy)
	local t1 = {}
	local t2 = {}
	local t3 = {}

	if p1.itemData then
		for _, v12 in p1.itemData do
			if v12.purchasableState == PurchasableStateEnum.Purchasable then
				table.insert(t1, createPurchasableItem(v12))

				if v12.ownedCount and v12.ownedCount > 0 then
					table.insert(t2, createOwnedItem(v12))
				end
			else
				table.insert(t3, createUnpurchasableItem(v12))
			end
		end
	end

	return {
		totalCost = p1.totalCost or 0,
		items = t1,
		ownedItems = t2,
		unpurchasableItems = t3,
		balance = p1.balance or 0,
		discountInformation = p1.discountInformation
	}
end

return selectBulkPurchaseRequestState
