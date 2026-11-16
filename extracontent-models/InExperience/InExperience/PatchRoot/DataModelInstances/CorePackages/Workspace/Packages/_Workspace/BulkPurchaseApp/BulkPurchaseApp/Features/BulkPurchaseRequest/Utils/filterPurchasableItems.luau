local BulkPurchaseApp = script:FindFirstAncestor("BulkPurchaseApp")

require(BulkPurchaseApp.Store.Types)
local PurchasableStateEnum = require(BulkPurchaseApp.Enums.PurchasableStateEnum)

local function filterPurchasableItems(items)
	local result = {}

	for _, item in items do
		if item.purchasableState == PurchasableStateEnum.Purchasable then
			table.insert(result, item)
		end
	end

	return result
end

return filterPurchasableItems
