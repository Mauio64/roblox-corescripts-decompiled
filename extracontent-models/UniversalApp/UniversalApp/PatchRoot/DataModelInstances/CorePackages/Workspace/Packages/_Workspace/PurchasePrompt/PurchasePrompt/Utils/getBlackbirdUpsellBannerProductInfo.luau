local Parent = script:FindFirstAncestor("PurchasePrompt").Parent

require(Parent.RobloxSubscriptionPurchaseApp)

local function getBlackbirdUpsellBannerProductInfo(p1) -- line: 11
	if type(p1) ~= "table" or #p1 == 0 then
		return nil
	end

	local v4 = p1[1]
	local v5 = false

	if v4.EligibleOffers and v4.EligibleOffers[1] then
		v5 = v4.EligibleOffers[1].OfferType == "FreeTrial"
	end

	local DiscountPercent = nil
	local v7 = v4.ProductTypeDetails and (v4.ProductTypeDetails.RobloxSubscriptionProductDetails and v4.ProductTypeDetails.RobloxSubscriptionProductDetails.FeatureConfig)

	if v7 and v7.VirtualTransactionDiscounts then
		local v8 = v7.VirtualTransactionDiscounts[1]

		if v8 then
			DiscountPercent = v8.DiscountPercent
		end
	end

	return {
		isFreeTrial = v5,
		initialDiscountPercentage = DiscountPercent
	}
end

return getBlackbirdUpsellBannerProductInfo
