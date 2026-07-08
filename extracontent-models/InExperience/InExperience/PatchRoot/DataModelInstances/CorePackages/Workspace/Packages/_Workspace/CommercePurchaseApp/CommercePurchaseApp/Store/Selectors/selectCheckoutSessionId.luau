local CommercePurchaseApp = script:FindFirstAncestor("CommercePurchaseApp")

require(CommercePurchaseApp.Store.Types)

local function selectCheckoutSessionId(p1) -- line: 7
	return p1.commercePurchaseState.checkoutSessionId
end

return selectCheckoutSessionId
