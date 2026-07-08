local BulkPurchaseApp = script:FindFirstAncestor("BulkPurchaseApp")

require(BulkPurchaseApp.Store.Types)

local PurchasableStateEnum = require(BulkPurchaseApp.Enums.PurchasableStateEnum)

local function filterPurchasableItems(t1: {[any]: any}) -- line: 8
	-- upvalues: PurchasableStateEnum (copy)
	local t2 = {}

	for _, v7 in t1 do
		if v7.purchasableState == PurchasableStateEnum.Purchasable then
			table.insert(t2, v7)
		end
	end

	return t2
end

return filterPurchasableItems
