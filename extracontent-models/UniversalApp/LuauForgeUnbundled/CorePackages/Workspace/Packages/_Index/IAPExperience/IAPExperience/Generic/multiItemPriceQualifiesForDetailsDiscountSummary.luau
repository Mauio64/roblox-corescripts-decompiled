local discountType = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/ProductPurchase/PricingTypes").DiscountType

local function multiItemPriceQualifiesForDetailsDiscountSummary(p2): boolean
	if not p2 then
		return false
	end

	if #p2.discounts >= 2 then
		return true
	end

	for k, discount in p2.discounts do
		if
			discount.type == discountType.BlackbirdSubscription
			or discount.type == discountType.RobloxPlusSubscription
		then
			return true
		end
	end

	return false
end

return multiItemPriceQualifiesForDetailsDiscountSummary
