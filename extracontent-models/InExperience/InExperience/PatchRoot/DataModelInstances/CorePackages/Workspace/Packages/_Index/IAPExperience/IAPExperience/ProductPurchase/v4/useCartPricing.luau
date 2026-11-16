local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local React = require(parent2.React)

require(parent.Generic.ProductDetailsContainer)
require(script.Parent.aggregateCartPricingForMultiItem)
require(script.Parent.cartPricingResponseLineItem)
local deriveCartPricingView = require(script.Parent.deriveCartPricingView)

local UnifiedPurchaseModalTypeEnum = require(parent.Enums.UnifiedPurchaseModalTypeEnum)

require(parent.ProductPurchase.PricingTypes)

local function useCartPricing(data)
	local v = React.useMemo(function()
		return deriveCartPricingView(data.cartPricingResponse)
	end, { data.cartPricingResponse })

	local cartPricingOffers = v == nil and {} or v.offers

	local cartAggregate = v ~= nil and v.hasSavings and {
		subtotalRobux = v.originalPrice,
		totalRobux = v.priceAfterDiscount,
		savingsRobux = v.originalPrice - v.priceAfterDiscount,
		itemCount = v.itemCount
	} or nil
	local priceWithoutOffersDiscounts

	if v ~= nil then
		priceWithoutOffersDiscounts = v.priceWithoutOffersDiscounts
	end

	local priceAfterDiscount

	if v ~= nil then
		priceAfterDiscount = v.priceAfterDiscount
	end

	local shouldHideLookProductDetails = data.purchaseModalType == UnifiedPurchaseModalTypeEnum.MultiItem
	local showCartOfferUi = cartAggregate ~= nil or #cartPricingOffers > 0

	local v2 = React.useMemo(function()
		if showCartOfferUi and cartAggregate ~= nil and v ~= nil then
			return {
				basePriceInRobux = cartAggregate.subtotalRobux,
				priceInRobux = cartAggregate.totalRobux,
				discounts = v.discounts
			}
		end

		return nil
	end, { showCartOfferUi, cartAggregate, v })

	local mergedProductForDetails = React.useMemo(function()
		if showCartOfferUi and cartAggregate ~= nil then
			return {
				model = data.product.model,
				itemIcon = data.product.itemIcon,
				itemName = data.product.itemName,
				itemRobuxCost = cartAggregate.totalRobux,
				itemPrice = v2 or data.product.itemPrice,
				itemDisplayPrice = data.product.itemDisplayPrice,
				badgeType = data.product.badgeType
			}
		end

		return data.product
	end, { data.product, showCartOfferUi, cartAggregate, v2 })

	local itemPrice = mergedProductForDetails.itemPrice
	local mergedProductPriceInRobux

	if itemPrice then
		mergedProductPriceInRobux = itemPrice.priceInRobux
	else
		mergedProductPriceInRobux = mergedProductForDetails.itemRobuxCost
	end

	local displayItemPriceForMultiItem

	if showCartOfferUi then
		displayItemPriceForMultiItem = v2 or data.product.itemPrice
	else
		displayItemPriceForMultiItem = data.product.itemPrice
	end

	local cartPricingSavingsSummary

	if showCartOfferUi and v ~= nil then
		cartPricingSavingsSummary = v.savingsSummary
	end

	return {
		cartAggregate = cartAggregate,
		priceWithoutOffersDiscounts = priceWithoutOffersDiscounts,
		priceAfterOffersDiscounts = priceAfterDiscount,
		shouldHideLookProductDetails = shouldHideLookProductDetails,
		cartPricingOffers = cartPricingOffers,
		showCartOfferUi = showCartOfferUi,
		mergedProductForDetails = mergedProductForDetails,
		mergedProductItemPrice = itemPrice,
		mergedProductPriceInRobux = mergedProductPriceInRobux,
		displayItemPriceForMultiItem = displayItemPriceForMultiItem,
		cartPricingSavingsSummary = cartPricingSavingsSummary,
		toggleCartPricingOffer = React.useCallback(function(p: string)
			local onCartOfferAppliedChanged = data.onCartOfferAppliedChanged

			if onCartOfferAppliedChanged == nil then
				return
			end

			local offerIds = {}
			local v3 = true

			for _, v4 in cartPricingOffers do
				local v5

				if v4.offerId == p then
					v5 = not v4.selected
				else
					v5 = v4.selected
				end

				if v5 then
					continue
				end

				table.insert(offerIds, v4.offerId)
				v3 = false
			end

			onCartOfferAppliedChanged(v3, offerIds)
		end, { cartPricingOffers, data.onCartOfferAppliedChanged })
	}
end

return useCartPricing
