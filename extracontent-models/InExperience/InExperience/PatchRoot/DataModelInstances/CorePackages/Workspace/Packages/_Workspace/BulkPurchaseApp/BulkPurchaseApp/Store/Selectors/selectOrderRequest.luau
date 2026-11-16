local BulkPurchaseApp = script:FindFirstAncestor("BulkPurchaseApp")

require(BulkPurchaseApp.Store.Types)

local function selectOrderRequest(p)
	return p.orderRequest
end

return selectOrderRequest
