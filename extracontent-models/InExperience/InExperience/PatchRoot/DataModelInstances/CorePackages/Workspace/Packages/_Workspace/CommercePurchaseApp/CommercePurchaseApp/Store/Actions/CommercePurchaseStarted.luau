local parent = script:FindFirstAncestor("CommercePurchaseApp").Parent
local Rodux = require(parent.Rodux)

return Rodux.makeActionCreator("CommercePurchaseStarted", function(commerceProductId: string)
	return { commerceProductId = commerceProductId }
end)
