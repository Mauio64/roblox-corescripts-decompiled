require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/ProductPurchase/PricingTypes")

local multiItemPriceQualifiesForDetailsDiscountSummary = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/multiItemPriceQualifiesForDetailsDiscountSummary")

local function multiItemPriceShowsDiscountAccordion(p2)
	if not p2 then
		return false
	end

	local basePriceInRobux = p2.basePriceInRobux
	local priceInRobux = p2.priceInRobux

	if
		typeof(basePriceInRobux) == "number"
		and typeof(priceInRobux) == "number"
		and not (basePriceInRobux <= priceInRobux)
	then
		return multiItemPriceQualifiesForDetailsDiscountSummary(p2)
	end

	return false
end

return multiItemPriceShowsDiscountAccordion
