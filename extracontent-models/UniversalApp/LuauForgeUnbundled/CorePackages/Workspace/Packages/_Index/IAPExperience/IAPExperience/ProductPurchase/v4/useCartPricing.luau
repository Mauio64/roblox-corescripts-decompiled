local React = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/React")

require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/ProductDetailsContainer")
require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/ProductPurchase/v4/aggregateCartPricingForMultiItem")
require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/ProductPurchase/v4/cartPricingResponseLineItem")
local deriveCartPricingView = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/ProductPurchase/v4/deriveCartPricingView")

local UnifiedPurchaseModalTypeEnum = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Enums/UnifiedPurchaseModalTypeEnum")

require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/ProductPurchase/PricingTypes")

local function useCartPricing(data)
	local v5 = React.useMemo(function()
		return deriveCartPricingView(data.cartPricingResponse)
	end, { data.cartPricingResponse })

	local v6 = v5 == nil and {} or v5.offers

	local v7 = v5 ~= nil and v5.hasSavings and {
		subtotalRobux = v5.originalPrice,
		totalRobux = v5.priceAfterDiscount,
		savingsRobux = v5.originalPrice - v5.priceAfterDiscount,
		itemCount = v5.itemCount
	} or nil

	local priceWithoutOffersDiscounts = if v5 ~= nil then v5.priceWithoutOffersDiscounts else nil

	local priceAfterDiscount = if v5 ~= nil then v5.priceAfterDiscount else nil

	local v8 = data.purchaseModalType == UnifiedPurchaseModalTypeEnum.MultiItem
	local v9 = v7 ~= nil or #v6 > 0

	local v10 = React.useMemo(function()
		if v9 and v7 ~= nil and v5 ~= nil then
			return {
				basePriceInRobux = v7.subtotalRobux,
				priceInRobux = v7.totalRobux,
				discounts = v5.discounts
			}
		end

		return nil
	end, { v9, v7, v5 })

	local v11 = React.useMemo(function()
		if v9 and v7 ~= nil then
			return {
				model = data.product.model,
				itemIcon = data.product.itemIcon,
				itemName = data.product.itemName,
				itemRobuxCost = v7.totalRobux,
				itemPrice = v10 or data.product.itemPrice,
				itemDisplayPrice = data.product.itemDisplayPrice,
				badgeType = data.product.badgeType
			}
		end

		return data.product
	end, { data.product, v9, v7, v10 })

	local itemPrice = v11.itemPrice

	local v12 = if itemPrice then itemPrice.priceInRobux else v11.itemRobuxCost

	local v13 = if v9 then v10 or data.product.itemPrice else data.product.itemPrice

	local v14 = if v9 and v5 ~= nil then v5.savingsSummary else nil

	return {
		cartAggregate = v7,
		priceWithoutOffersDiscounts = priceWithoutOffersDiscounts,
		priceAfterOffersDiscounts = priceAfterDiscount,
		shouldHideLookProductDetails = v8,
		cartPricingOffers = v6,
		showCartOfferUi = v9,
		mergedProductForDetails = v11,
		mergedProductItemPrice = itemPrice,
		mergedProductPriceInRobux = v12,
		displayItemPriceForMultiItem = v13,
		cartPricingSavingsSummary = v14,
		toggleCartPricingOffer = React.useCallback(function(p2)
			local onCartOfferAppliedChanged = data.onCartOfferAppliedChanged

			if onCartOfferAppliedChanged == nil then
				return
			end

			local offerIds = {}
			local v15 = true

			for k, v16 in v6 do
				local v17 = if v16.offerId == p2 then not v16.selected else v16.selected

				if v17 then
					continue
				end

				table.insert(offerIds, v16.offerId)
				v15 = false
			end

			onCartOfferAppliedChanged(v15, offerIds)
		end, { v6, data.onCartOfferAppliedChanged })
	}
end

return useCartPricing
