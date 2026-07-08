local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)

require(ParentParent.Generic.ProductDetailsContainer)
require(script.Parent.aggregateCartPricingForMultiItem)
require(script.Parent.cartPricingResponseLineItem)

local deriveCartPricingView = require(script.Parent.deriveCartPricingView)
local UnifiedPurchaseModalTypeEnum = require(ParentParent.Enums.UnifiedPurchaseModalTypeEnum)

require(ParentParent.ProductPurchase.PricingTypes)

local FFlagPurchasePromptFetchCartPricing = require(ParentParent.Parent.SharedFlags).FFlagPurchasePromptFetchCartPricing

local function useCartPricing(t1: {[any]: any}) -- line: 43
	-- upvalues: React (copy), FFlagPurchasePromptFetchCartPricing (copy), deriveCartPricingView (copy), UnifiedPurchaseModalTypeEnum (copy)
	local v9 = React.useMemo(function() -- line: 46
		-- upvalues: FFlagPurchasePromptFetchCartPricing (copy), deriveCartPricingView (copy), t1 (copy)
		if not FFlagPurchasePromptFetchCartPricing then
			return nil
		end

		return deriveCartPricingView(t1.cartPricingResponse)
	end, { t1.cartPricingResponse })
	local v10 = if v9 == nil then {} else v9.offers
	local v11 = if v9 == nil or not v9.hasSavings then nil else {
		subtotalRobux = v9.originalPrice,
		totalRobux = v9.priceAfterDiscount,
		savingsRobux = v9.originalPrice - v9.priceAfterDiscount,
		itemCount = v9.itemCount
	}
	local v12 = FFlagPurchasePromptFetchCartPricing and t1.purchaseModalType == UnifiedPurchaseModalTypeEnum.MultiItem
	local v13 = v11 ~= nil or #v10 > 0
	local v14 = React.useMemo(function() -- line: 75
		-- upvalues: v13 (copy), v11 (copy), v9 (copy)
		if not v13 or (v11 == nil or v9 == nil) then
			return nil
		end

		return {
			basePriceInRobux = v11.subtotalRobux,
			priceInRobux = v11.totalRobux,
			discounts = v9.discounts
		}
	end, {
		v13,
		v11,
		v9
	})
	local v15 = React.useMemo(function() -- line: 86
		-- upvalues: v13 (copy), v11 (copy), t1 (copy), v14 (copy)
		if not v13 or v11 == nil then
			return t1.product
		end

		return {
			model = t1.product.model,
			itemIcon = t1.product.itemIcon,
			itemName = t1.product.itemName,
			itemRobuxCost = v11.totalRobux,
			itemPrice = v14 or t1.product.itemPrice,
			itemDisplayPrice = t1.product.itemDisplayPrice,
			badgeType = t1.product.badgeType
		}
	end, {
		t1.product,
		v13,
		v11,
		v14
	})
	local itemPrice = v15.itemPrice
	local v17 = if not itemPrice then v15.itemRobuxCost else itemPrice.priceInRobux
	local v18 = if not v13 then t1.product.itemPrice else v14 or t1.product.itemPrice
	local v19 = if not v13 or v9 == nil then nil else v9.savingsSummary
	local v20 = React.useCallback(function(s1: string) -- line: 112
		-- upvalues: t1 (copy), v10 (copy)
		local onCartOfferAppliedChanged = t1.onCartOfferAppliedChanged

		if onCartOfferAppliedChanged == nil then
			return
		end

		local t2 = {}
		local v24 = true

		for _, v26 in v10 do
			if not if s1 ~= v26.offerId then v26.selected else not v26.selected then
				table.insert(t2, v26.offerId)
				v24 = false
			end
		end

		onCartOfferAppliedChanged(v24, t2)
	end, {
		v10,
		t1.onCartOfferAppliedChanged
	})

	return {
		cartAggregate = v11,
		shouldHideLookProductDetails = v12,
		cartPricingOffers = v10,
		showCartOfferUi = v13,
		mergedProductForDetails = v15,
		mergedProductItemPrice = itemPrice,
		mergedProductPriceInRobux = v17,
		displayItemPriceForMultiItem = v18,
		cartPricingSavingsSummary = v19,
		toggleCartPricingOffer = v20
	}
end

return useCartPricing
