require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Reducers/CartPricingReducer")

local function selectIsCartPricingFetching(p2): boolean
	local cartPricing = p2.cartPricing

	if cartPricing == nil then
		return false
	end

	return cartPricing.isFetching == true
end

return selectIsCartPricingFetching
