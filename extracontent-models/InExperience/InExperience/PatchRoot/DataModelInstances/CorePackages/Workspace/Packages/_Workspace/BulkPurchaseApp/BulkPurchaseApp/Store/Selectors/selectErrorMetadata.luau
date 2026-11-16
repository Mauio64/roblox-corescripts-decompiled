local BulkPurchaseApp = script:FindFirstAncestor("BulkPurchaseApp")

require(BulkPurchaseApp.Store.Types)

local function selectErrorMetadata(p)
	return p.errorMetadata
end

return selectErrorMetadata
