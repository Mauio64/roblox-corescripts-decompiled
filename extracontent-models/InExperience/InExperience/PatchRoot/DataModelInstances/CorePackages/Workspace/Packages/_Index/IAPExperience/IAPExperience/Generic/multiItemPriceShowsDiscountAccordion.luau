local IAPExperience = script:FindFirstAncestor("IAPExperience")
require(IAPExperience.ProductPurchase.PricingTypes)

local multiItemPriceQualifiesForDetailsDiscountSummary = require(IAPExperience.Generic.multiItemPriceQualifiesForDetailsDiscountSummary)

local function multiItemPriceShowsDiscountAccordion(p)
	if not p then
		return false
	end

	local basePriceInRobux = p.basePriceInRobux
	local priceInRobux = p.priceInRobux

	if
		typeof(basePriceInRobux) == "number"
		and typeof(priceInRobux) == "number"
		and not (basePriceInRobux <= priceInRobux)
	then
		return multiItemPriceQualifiesForDetailsDiscountSummary(p)
	end

	return false
end

return multiItemPriceShowsDiscountAccordion
