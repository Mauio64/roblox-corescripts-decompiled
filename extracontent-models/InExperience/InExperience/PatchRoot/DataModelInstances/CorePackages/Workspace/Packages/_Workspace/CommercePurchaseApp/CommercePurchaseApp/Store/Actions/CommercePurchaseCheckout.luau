local parent = script:FindFirstAncestor("CommercePurchaseApp").Parent
local Rodux = require(parent.Rodux)

return Rodux.makeActionCreator("CommercePurchaseCheckout", function(checkoutSessionId: string)
	return { checkoutSessionId = checkoutSessionId }
end)
