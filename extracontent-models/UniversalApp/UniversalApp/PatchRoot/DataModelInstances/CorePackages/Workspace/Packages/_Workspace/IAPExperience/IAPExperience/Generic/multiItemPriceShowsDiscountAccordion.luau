local IAPExperience = script:FindFirstAncestor("IAPExperience")

require(IAPExperience.ProductPurchase.PricingTypes)

local multiItemPriceQualifiesForDetailsDiscountSummary = require(IAPExperience.Generic.multiItemPriceQualifiesForDetailsDiscountSummary)

local function multiItemPriceShowsDiscountAccordion(p1) -- line: 16
	-- upvalues: multiItemPriceQualifiesForDetailsDiscountSummary (copy)
	if not p1 then
		return false
	end

	local basePriceInRobux = p1.basePriceInRobux
	local priceInRobux = p1.priceInRobux

	if typeof(basePriceInRobux) ~= "number" or typeof(priceInRobux) ~= "number" or basePriceInRobux <= priceInRobux then
		return false
	end

	return multiItemPriceQualifiesForDetailsDiscountSummary(p1)
end

return multiItemPriceShowsDiscountAccordion
