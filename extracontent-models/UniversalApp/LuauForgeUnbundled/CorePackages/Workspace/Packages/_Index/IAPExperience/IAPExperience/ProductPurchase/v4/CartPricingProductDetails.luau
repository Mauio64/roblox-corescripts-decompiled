local React = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/React")

local view = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Foundation").View

local ProductDetailsContainer = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/ProductDetailsContainer")
local module3 = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/ProductPurchase/v4/CartPricingLoading")
require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/ProductPurchase/v4/useCartPricing")

require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Enums/UnifiedPurchaseModalTypeEnum")

local fFlagUnifiedPurchaseAddSkeleton = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/SharedFlags").FFlagUnifiedPurchaseAddSkeleton

local fFlagLuaAppsEnablePromptVIPServerPurchase = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/SharedFlags").FFlagLuaAppsEnablePromptVIPServerPurchase

local function CartPricingProductDetails(props)
	local cartPricing = props.cartPricing
	local v5

	if props.isCartPricingLoading then
		v5 = React.createElement(module3, {
			LayoutOrder = 2,
			isLoading = props.isCartPricingLoading
		})
	end

	local createElement = React.createElement

	local createElement2 = React.createElement
	local v10 = {
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

	local v11 = if fFlagLuaAppsEnablePromptVIPServerPurchase then props.includePriceSuffixOnOriginal else nil
	v10.includePriceSuffixOnOriginal = v11

	local v12 = if fFlagLuaAppsEnablePromptVIPServerPurchase then props.priceText else nil
	v10.priceText = v12
	local v13 = if fFlagUnifiedPurchaseAddSkeleton then props.isLoading else nil
	v10.isLoading = v13
	local v14 = if cartPricing.showCartOfferUi and cartPricing.cartAggregate then cartPricing.cartAggregate.itemCount else nil
	v10.subtotalItemCount = v14

	v10.hideProductDetails = cartPricing.shouldHideLookProductDetails
	v10.hideDiscountSummary = props.isCartPricingLoading
	v10.savingsSummary = cartPricing.cartPricingSavingsSummary
	return createElement(
		view,
		{
			tag = "col align-x-center align-y-center gap-medium size-full-0 auto-y",
			LayoutOrder = 1
		},
		{ Details = createElement2(ProductDetailsContainer, v10), CartPricingLoading = v5 }
	)
end

return CartPricingProductDetails
