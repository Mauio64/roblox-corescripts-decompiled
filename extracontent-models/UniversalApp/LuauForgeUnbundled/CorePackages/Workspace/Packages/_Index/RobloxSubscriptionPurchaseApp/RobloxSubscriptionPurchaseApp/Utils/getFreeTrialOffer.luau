require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Models/GetRobloxSubscriptionProductsModel")

local function getFreeTrialOffer(p2)
	if not p2 then
		return nil
	end

	local eligibleOffers = p2.EligibleOffers
	local v5 = eligibleOffers and eligibleOffers[1]

	if v5 == nil or v5.OfferType ~= "FreeTrial" then
		return nil
	end

	return v5
end

return getFreeTrialOffer
