local BulkPurchaseApp = script:FindFirstAncestor("BulkPurchaseApp")
local parent = BulkPurchaseApp.Parent
local Rodux = require(parent.Rodux)

require(BulkPurchaseApp.Enums.ErrorCodeEnum)

return Rodux.makeActionCreator("BulkPurchaseFailed", function(errorCode, errorMetadata)
	return { errorCode = errorCode, errorMetadata = errorMetadata }
end)
