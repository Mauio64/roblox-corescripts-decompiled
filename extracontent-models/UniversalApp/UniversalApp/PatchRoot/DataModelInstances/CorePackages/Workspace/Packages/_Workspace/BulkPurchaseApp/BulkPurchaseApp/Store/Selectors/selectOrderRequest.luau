local BulkPurchaseApp = script:FindFirstAncestor("BulkPurchaseApp")

require(BulkPurchaseApp.Store.Types)

local function selectOrderRequest(p1) -- line: 8
	return p1.orderRequest
end

return selectOrderRequest
