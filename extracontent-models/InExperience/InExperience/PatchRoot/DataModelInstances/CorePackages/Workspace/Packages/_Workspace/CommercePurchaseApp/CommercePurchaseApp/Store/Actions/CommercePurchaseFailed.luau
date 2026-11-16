local CommercePurchaseApp = script:FindFirstAncestor("CommercePurchaseApp")
local parent = CommercePurchaseApp.Parent
local Rodux = require(parent.Rodux)

require(CommercePurchaseApp.Enums.ErrorCodeEnum)

return Rodux.makeActionCreator("CommercePurchaseFailed", function(errorCode)
	return { errorCode = errorCode }
end)
