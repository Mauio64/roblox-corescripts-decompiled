local BulkPurchaseApp = script:FindFirstAncestor("BulkPurchaseApp")

require(BulkPurchaseApp.Store.Types)

local function selectItemData(p1) -- line: 8
	return p1.itemData or {}
end

return selectItemData
