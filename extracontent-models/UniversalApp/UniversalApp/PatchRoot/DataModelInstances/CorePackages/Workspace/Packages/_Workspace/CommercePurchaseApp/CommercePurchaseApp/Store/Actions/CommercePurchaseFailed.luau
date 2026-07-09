local CommercePurchaseApp = script:FindFirstAncestor("CommercePurchaseApp")
local CommercePurchaseAppParent = CommercePurchaseApp.Parent
local Rodux = require(CommercePurchaseAppParent.Rodux)

require(CommercePurchaseApp.Enums.ErrorCodeEnum)

return Rodux.makeActionCreator("CommercePurchaseFailed", function(p1) -- line: 12
	return {
		errorCode = p1
	}
end)
