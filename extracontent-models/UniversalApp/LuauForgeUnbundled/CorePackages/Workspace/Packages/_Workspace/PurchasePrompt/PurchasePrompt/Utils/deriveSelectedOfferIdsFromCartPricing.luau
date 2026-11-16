local deriveCartPricingView = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/IAPExperience").deriveCartPricingView

local function deriveSelectedOfferIdsFromCartPricing(p2)
	local v5 = deriveCartPricingView(p2)

	if v5 == nil then
		return {}
	end

	return v5.selectedOfferIds
end

return deriveSelectedOfferIdsFromCartPricing
