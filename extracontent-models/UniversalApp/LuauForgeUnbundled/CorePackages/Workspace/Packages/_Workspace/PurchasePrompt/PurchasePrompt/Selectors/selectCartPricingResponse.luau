require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/IAPExperience")

local function selectCartPricingResponse(p2)
	local cartPricing = p2.cartPricing

	if cartPricing == nil then
		return nil
	end

	return cartPricing.response
end

return selectCartPricingResponse
