local BulkPurchaseApp = script:FindFirstAncestor("BulkPurchaseApp")
local BulkPurchaseAppParent = BulkPurchaseApp.Parent
local Rodux = require(BulkPurchaseAppParent.Rodux)

require(BulkPurchaseApp.Enums.BulkPurchasePromptStateEnum)

return Rodux.makeActionCreator("BulkPurchaseSucceeded", function(p1, t1: {[any]: any}) -- line: 15
	return {
		promptState = p1,
		itemStatuses = t1
	}
end)
