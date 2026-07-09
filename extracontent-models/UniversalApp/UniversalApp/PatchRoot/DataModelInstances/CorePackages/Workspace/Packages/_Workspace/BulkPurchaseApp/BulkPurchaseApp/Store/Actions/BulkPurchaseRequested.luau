local BulkPurchaseApp = script:FindFirstAncestor("BulkPurchaseApp")
local BulkPurchaseAppParent = BulkPurchaseApp.Parent
local Rodux = require(BulkPurchaseAppParent.Rodux)

require(BulkPurchaseApp.Store.Types)

return Rodux.makeActionCreator("BulkPurchaseRequested", function(t1: {[any]: any}, p1, n1: number, n2: number, p2, p3) -- line: 24
	return {
		itemData = t1,
		balance = n1,
		totalCost = n2,
		orderRequest = p1,
		options = p2,
		discountInformation = p3
	}
end)
