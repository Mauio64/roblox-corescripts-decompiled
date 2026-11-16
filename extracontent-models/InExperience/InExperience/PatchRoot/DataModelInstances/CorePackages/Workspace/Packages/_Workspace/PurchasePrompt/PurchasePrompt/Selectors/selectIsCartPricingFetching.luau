local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")

require(PurchasePrompt.Reducers.CartPricingReducer)

local function selectIsCartPricingFetching(p): boolean
	local cartPricing = p.cartPricing

	return cartPricing ~= nil and cartPricing.isFetching == true
end

return selectIsCartPricingFetching
