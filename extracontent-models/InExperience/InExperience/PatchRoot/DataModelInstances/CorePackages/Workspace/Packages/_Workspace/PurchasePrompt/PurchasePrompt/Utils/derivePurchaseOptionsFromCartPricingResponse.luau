local Parent = script:FindFirstAncestor("PurchasePrompt").Parent

require(Parent.IAPExperience)

local deriveSelectedOfferIdsFromCartPricing = require(script.Parent.deriveSelectedOfferIdsFromCartPricing)

local function derivePurchaseOptionsFromCartPricingResponse(p1) -- line: 18
	-- upvalues: deriveSelectedOfferIdsFromCartPricing (copy)
	if p1 == nil then
		return nil
	end

	local v5 = deriveSelectedOfferIdsFromCartPricing(p1)

	if #v5 == 0 then
		return nil
	end

	local t1 = {}

	for _, v8 in v5 do
		table.insert(t1, {
			Id = v8
		})
	end

	return {
		Offers = t1
	}
end

return derivePurchaseOptionsFromCartPricingResponse
