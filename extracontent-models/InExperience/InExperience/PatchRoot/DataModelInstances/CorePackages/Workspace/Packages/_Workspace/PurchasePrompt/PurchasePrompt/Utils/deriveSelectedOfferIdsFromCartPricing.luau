local Parent = script:FindFirstAncestor("PurchasePrompt").Parent
local deriveCartPricingView = require(Parent.IAPExperience).deriveCartPricingView

local function deriveSelectedOfferIdsFromCartPricing(p1) -- line: 14
	-- upvalues: deriveCartPricingView (copy)
	local v5 = deriveCartPricingView(p1)

	if v5 == nil then
		return {}
	end

	return v5.selectedOfferIds
end

return deriveSelectedOfferIdsFromCartPricing
