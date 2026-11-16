require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/IAPExperience")

require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/types")
local deriveSelectedOfferIdsFromCartPricing = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/deriveSelectedOfferIdsFromCartPricing")

local function derivePurchaseOptionsFromCartPricingResponse(p2)
	if p2 == nil then
		return nil
	end

	local v5 = deriveSelectedOfferIdsFromCartPricing(p2)

	if #v5 == 0 then
		return nil
	end

	local v6 = {}

	for k, v7 in v5 do
		table.insert(v6, { Id = v7 })
	end

	return { Offers = v6 }
end

return derivePurchaseOptionsFromCartPricingResponse
