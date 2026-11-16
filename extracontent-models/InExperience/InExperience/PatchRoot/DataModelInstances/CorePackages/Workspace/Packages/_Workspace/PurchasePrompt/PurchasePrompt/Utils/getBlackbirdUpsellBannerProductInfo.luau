local parent = script:FindFirstAncestor("PurchasePrompt").Parent

require(parent.RobloxSubscriptionPurchaseApp)

local function getBlackbirdUpsellBannerProductInfo(list)
	if type(list) ~= "table" or #list == 0 then
		return nil
	end

	local item = list[1]
	local isFreeTrial

	if item.EligibleOffers and item.EligibleOffers[1] then
		isFreeTrial = item.EligibleOffers[1].OfferType == "FreeTrial"
	else
		isFreeTrial = false
	end

	local discountPercent = nil
	local featureConfig = item.ProductTypeDetails
		and item.ProductTypeDetails.RobloxSubscriptionProductDetails
		and item.ProductTypeDetails.RobloxSubscriptionProductDetails.FeatureConfig

	if featureConfig and featureConfig.VirtualTransactionDiscounts then
		local virtualTransactionDiscount = featureConfig.VirtualTransactionDiscounts[1]

		if virtualTransactionDiscount then
			discountPercent = virtualTransactionDiscount.DiscountPercent
		end
	end

	return { isFreeTrial = isFreeTrial, initialDiscountPercentage = discountPercent }
end

return getBlackbirdUpsellBannerProductInfo
