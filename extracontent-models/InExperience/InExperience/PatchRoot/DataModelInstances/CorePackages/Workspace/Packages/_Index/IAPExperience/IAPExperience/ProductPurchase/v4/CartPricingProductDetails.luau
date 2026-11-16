local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local React = require(parent2.React)

local Foundation = require(parent2.Foundation)
local View = Foundation.View

local ProductDetailsContainer = require(parent.Generic.ProductDetailsContainer)
local CartPricingLoading = require(script.Parent.CartPricingLoading)
require(script.Parent.useCartPricing)

require(parent.Enums.UnifiedPurchaseModalTypeEnum)

local SharedFlags = require(parent.Parent.SharedFlags)
local FFlagUnifiedPurchaseAddSkeleton = SharedFlags.FFlagUnifiedPurchaseAddSkeleton

local SharedFlags2 = require(parent.Parent.SharedFlags)
local FFlagLuaAppsEnablePromptVIPServerPurchase = SharedFlags2.FFlagLuaAppsEnablePromptVIPServerPurchase

local function CartPricingProductDetails(props)
	local cartPricing = props.cartPricing
	local cartPricingLoading

	if props.isCartPricingLoading then
		cartPricingLoading = React.createElement(CartPricingLoading, {
			LayoutOrder = 2,
			isLoading = props.isCartPricingLoading
		})
	end

	local createElement = React.createElement

	local createElement2 = React.createElement
	local v = {
		purchaseModalType = props.purchaseModalType,
		product = cartPricing.mergedProductForDetails,
		subtitleView = props.subtitleView,
		priceSuffix = props.priceSuffix,
		includePriceSuffixOnOriginal = 0,
		priceText = 0,
		isLoading = 0,
		subtotalItemCount = 0,
		hideProductDetails = 0,
		hideDiscountSummary = 0,
		savingsSummary = 0
	}
	local includePriceSuffixOnOriginal

	if FFlagLuaAppsEnablePromptVIPServerPurchase then
		includePriceSuffixOnOriginal = props.includePriceSuffixOnOriginal
	end

	v.includePriceSuffixOnOriginal = includePriceSuffixOnOriginal
	local priceText

	if FFlagLuaAppsEnablePromptVIPServerPurchase then
		priceText = props.priceText
	end

	v.priceText = priceText
	local isLoading

	if FFlagUnifiedPurchaseAddSkeleton then
		isLoading = props.isLoading
	end

	v.isLoading = isLoading
	local subtotalItemCount

	if cartPricing.showCartOfferUi and cartPricing.cartAggregate then
		subtotalItemCount = cartPricing.cartAggregate.itemCount
	end

	v.subtotalItemCount = subtotalItemCount

	v.hideProductDetails = cartPricing.shouldHideLookProductDetails
	v.hideDiscountSummary = props.isCartPricingLoading
	v.savingsSummary = cartPricing.cartPricingSavingsSummary
	return createElement(
		View,
		{ tag = "col align-x-center align-y-center gap-medium size-full-0 auto-y", LayoutOrder = 1 },
		{
			Details = createElement2(ProductDetailsContainer, v),
			CartPricingLoading = cartPricingLoading
		}
	)
end

return CartPricingProductDetails
