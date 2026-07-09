local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")

require(PurchasePrompt.Reducers.CartPricingReducer)

local function selectIsCartPricingFetching(t1: {[any]: any}) -- line: 15
	local cartPricing = t1.cartPricing

	if cartPricing == nil then
		return false
	end

	return cartPricing.isFetching == true
end

return selectIsCartPricingFetching
