local function isRobloxSubscriptionProductFreeTrial(p1) -- line: 4
	if not p1 then
		return false
	end

	local EligibleOffers = p1.EligibleOffers
	local v4 = EligibleOffers and EligibleOffers[1]

	return v4 ~= nil and v4.OfferType == "FreeTrial"
end

return isRobloxSubscriptionProductFreeTrial
