local BulkPurchaseApp = script:FindFirstAncestor("BulkPurchaseApp")

require(BulkPurchaseApp.Enums.ErrorCodeEnum)
require(BulkPurchaseApp.Store.Types)

local function selectErrorCode(p1) -- line: 8
	return p1.errorCode
end

return selectErrorCode
