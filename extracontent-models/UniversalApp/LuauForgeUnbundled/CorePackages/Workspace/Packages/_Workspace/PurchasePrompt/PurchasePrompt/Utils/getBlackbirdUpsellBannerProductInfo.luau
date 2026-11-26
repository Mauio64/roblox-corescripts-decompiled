require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/RobloxSubscriptionPurchaseApp")

local function getBlackbirdUpsellBannerProductInfo(list)
	if type(list) ~= "table" or #list == 0 then
		return nil
	end

	local item = list[1]
	local v5

	if item.EligibleOffers and item.EligibleOffers[1] then
		v5 = item.EligibleOffers[1].OfferType == "FreeTrial"
	else
		v5 = false
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

	return { isFreeTrial = v5, initialDiscountPercentage = discountPercent }
end

return getBlackbirdUpsellBannerProductInfo
