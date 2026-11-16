local parent = script:FindFirstAncestor("PurchasePrompt").Parent

require(parent.IAPExperience)

local function selectCartPricingResponse(p)
	local cartPricing = p.cartPricing

	return if cartPricing ~= nil then cartPricing.response else nil
end

return selectCartPricingResponse
