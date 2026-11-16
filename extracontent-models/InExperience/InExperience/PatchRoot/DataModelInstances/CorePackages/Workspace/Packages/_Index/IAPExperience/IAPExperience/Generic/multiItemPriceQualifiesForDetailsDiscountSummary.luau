local IAPExperience = script:FindFirstAncestor("IAPExperience")
local PricingTypes = require(IAPExperience.ProductPurchase.PricingTypes)
local DiscountType = PricingTypes.DiscountType

local function multiItemPriceQualifiesForDetailsDiscountSummary(p): boolean
	if not p then
		return false
	end

	if #p.discounts >= 2 then
		return true
	end

	for _, discount in p.discounts do
		if
			discount.type == DiscountType.BlackbirdSubscription
			or discount.type == DiscountType.RobloxPlusSubscription
		then
			return true
		end
	end

	return false
end

return multiItemPriceQualifiesForDetailsDiscountSummary
