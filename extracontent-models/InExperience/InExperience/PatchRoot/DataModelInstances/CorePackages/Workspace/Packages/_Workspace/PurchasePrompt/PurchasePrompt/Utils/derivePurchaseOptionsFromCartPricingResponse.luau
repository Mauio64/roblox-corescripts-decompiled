local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local parent = PurchasePrompt.Parent

require(parent.IAPExperience)

require(PurchasePrompt.types)
local deriveSelectedOfferIdsFromCartPricing = require(script.Parent.deriveSelectedOfferIdsFromCartPricing)

local function derivePurchaseOptionsFromCartPricingResponse(p)
	if p == nil then
		return nil
	end

	local v = deriveSelectedOfferIdsFromCartPricing(p)

	if #v == 0 then
		return nil
	end

	local offers = {}

	for _, id in v do
		table.insert(offers, { Id = id })
	end

	return { Offers = offers }
end

return derivePurchaseOptionsFromCartPricingResponse
