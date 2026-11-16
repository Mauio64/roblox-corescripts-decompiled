local CommercePurchaseApp = script:FindFirstAncestor("CommercePurchaseApp")

require(CommercePurchaseApp.Store.Types)

local function selectCheckoutSessionId(p)
	return p.commercePurchaseState.checkoutSessionId
end

return selectCheckoutSessionId
