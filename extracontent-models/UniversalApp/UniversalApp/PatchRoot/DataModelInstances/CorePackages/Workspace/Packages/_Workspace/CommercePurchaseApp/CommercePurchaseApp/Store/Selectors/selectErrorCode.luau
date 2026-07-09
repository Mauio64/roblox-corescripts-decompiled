local CommercePurchaseApp = script:FindFirstAncestor("CommercePurchaseApp")

require(CommercePurchaseApp.Enums.ErrorCodeEnum)
require(CommercePurchaseApp.Store.Types)

local function selectErrorCode(p1) -- line: 8
	return p1.commercePurchaseState.errorCode
end

return selectErrorCode
