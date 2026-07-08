local BulkPurchaseApp = script:FindFirstAncestor("BulkPurchaseApp")
local BulkPurchaseAppParent = BulkPurchaseApp.Parent
local Rodux = require(BulkPurchaseAppParent.Rodux)

require(BulkPurchaseApp.Enums.ErrorCodeEnum)

return Rodux.makeActionCreator("BulkPurchaseFailed", function(p1, t1: {[any]: any}?) -- line: 15
	return {
		errorCode = p1,
		errorMetadata = t1
	}
end)
