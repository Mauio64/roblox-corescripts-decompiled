local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)
local View = require(ParentParentParent.Foundation).View
local ProductDetailsContainer = require(ParentParent.Generic.ProductDetailsContainer)
local CartPricingLoading = require(script.Parent.CartPricingLoading)

require(script.Parent.useCartPricing)
require(ParentParent.Enums.UnifiedPurchaseModalTypeEnum)

local FFlagUnifiedPurchaseAddSkeleton = require(ParentParent.Parent.SharedFlags).FFlagUnifiedPurchaseAddSkeleton

local function CartPricingProductDetails(t1: {[any]: any}) -- line: 28
	-- upvalues: React (copy), CartPricingLoading (copy), View (copy), ProductDetailsContainer (copy), FFlagUnifiedPurchaseAddSkeleton (copy)
	local cartPricing = t1.cartPricing
	local v11 = if not t1.isCartPricingLoading then nil else React.createElement(CartPricingLoading, {
		LayoutOrder = 2,
		isLoading = t1.isCartPricingLoading
	})

	return React.createElement(View, {
		tag = "col align-x-center align-y-center gap-medium size-full-0 auto-y",
		LayoutOrder = 1
	}, {
		Details = React.createElement(ProductDetailsContainer, {
			purchaseModalType = t1.purchaseModalType,
			product = cartPricing.mergedProductForDetails,
			subtitleView = t1.subtitleView,
			priceSuffix = t1.priceSuffix,
			isLoading = if not FFlagUnifiedPurchaseAddSkeleton then nil else t1.isLoading,
			subtotalItemCount = if not cartPricing.showCartOfferUi or not cartPricing.cartAggregate then nil else cartPricing.cartAggregate.itemCount,
			hideProductDetails = cartPricing.shouldHideLookProductDetails,
			hideDiscountSummary = t1.isCartPricingLoading,
			savingsSummary = cartPricing.cartPricingSavingsSummary
		}),
		CartPricingLoading = v11
	})
end

return CartPricingProductDetails
