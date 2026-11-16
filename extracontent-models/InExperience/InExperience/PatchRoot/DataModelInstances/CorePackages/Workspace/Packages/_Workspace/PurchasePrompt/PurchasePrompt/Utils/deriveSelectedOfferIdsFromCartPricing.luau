local parent = script:FindFirstAncestor("PurchasePrompt").Parent

local IAPExperience = require(parent.IAPExperience)

local deriveCartPricingView = IAPExperience.deriveCartPricingView

local function deriveSelectedOfferIdsFromCartPricing(p)
	local v = deriveCartPricingView(p)

	if v == nil then
		return {}
	end

	return v.selectedOfferIds
end

return deriveSelectedOfferIdsFromCartPricing
