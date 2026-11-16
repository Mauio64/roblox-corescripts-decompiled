local CommercePurchaseApp = script:FindFirstAncestor("CommercePurchaseApp")

require(CommercePurchaseApp.Enums.ErrorCodeEnum)
require(CommercePurchaseApp.Store.Types)

local function selectErrorCode(p)
	return p.commercePurchaseState.errorCode
end

return selectErrorCode
