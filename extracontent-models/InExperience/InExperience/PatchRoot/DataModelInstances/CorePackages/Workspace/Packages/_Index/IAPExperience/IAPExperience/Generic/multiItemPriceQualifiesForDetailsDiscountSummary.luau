local IAPExperience = script:FindFirstAncestor("IAPExperience")
local DiscountType = require(IAPExperience.ProductPurchase.PricingTypes).DiscountType

local function multiItemPriceQualifiesForDetailsDiscountSummary(p1) -- line: 12
	-- upvalues: DiscountType (copy)
	if not p1 then
		return false
	end

	if #p1.discounts >= 2 then
		return true
	end

	for _, v6 in p1.discounts do
		if v6.type == DiscountType.BlackbirdSubscription or v6.type == DiscountType.RobloxPlusSubscription then
			return true
		end
	end

	return false
end

return multiItemPriceQualifiesForDetailsDiscountSummary
