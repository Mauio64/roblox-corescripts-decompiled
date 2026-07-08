local Parent = script:FindFirstAncestor("PurchasePrompt").Parent

require(Parent.IAPExperience)

local function selectCartPricingResponse(t1: {[any]: any}) -- line: 22
	local cartPricing = t1.cartPricing

	if cartPricing == nil then
		return nil
	end

	return cartPricing.response
end

return selectCartPricingResponse
