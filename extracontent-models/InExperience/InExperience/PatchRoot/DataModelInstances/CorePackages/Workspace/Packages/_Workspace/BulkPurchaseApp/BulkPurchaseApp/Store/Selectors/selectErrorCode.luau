local BulkPurchaseApp = script:FindFirstAncestor("BulkPurchaseApp")

require(BulkPurchaseApp.Enums.ErrorCodeEnum)
require(BulkPurchaseApp.Store.Types)

local function selectErrorCode(p)
	return p.errorCode
end

return selectErrorCode
