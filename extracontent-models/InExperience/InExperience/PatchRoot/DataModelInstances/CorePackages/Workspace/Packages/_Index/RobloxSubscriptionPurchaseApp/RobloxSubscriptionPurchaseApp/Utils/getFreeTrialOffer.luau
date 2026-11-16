local RobloxSubscriptionPurchaseApp = script:FindFirstAncestor("RobloxSubscriptionPurchaseApp")
require(RobloxSubscriptionPurchaseApp.Models.GetRobloxSubscriptionProductsModel)

local function getFreeTrialOffer(p)
	if not p then
		return nil
	end

	local eligibleOffers = p.EligibleOffers
	local selected = eligibleOffers and eligibleOffers[1]

	if selected == nil or selected.OfferType ~= "FreeTrial" then
		return nil
	end

	return selected
end

return getFreeTrialOffer
