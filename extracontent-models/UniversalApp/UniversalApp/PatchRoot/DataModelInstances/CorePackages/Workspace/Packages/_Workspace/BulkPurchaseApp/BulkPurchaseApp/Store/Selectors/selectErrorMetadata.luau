local BulkPurchaseApp = script:FindFirstAncestor("BulkPurchaseApp")

require(BulkPurchaseApp.Store.Types)

local function selectErrorMetadata(p1) -- line: 7
	return p1.errorMetadata
end

return selectErrorMetadata
