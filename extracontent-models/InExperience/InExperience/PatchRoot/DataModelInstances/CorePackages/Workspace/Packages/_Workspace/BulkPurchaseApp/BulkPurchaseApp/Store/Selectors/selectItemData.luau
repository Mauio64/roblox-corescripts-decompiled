local BulkPurchaseApp = script:FindFirstAncestor("BulkPurchaseApp")

require(BulkPurchaseApp.Store.Types)

local function selectItemData(p)
	return p.itemData or {}
end

return selectItemData
