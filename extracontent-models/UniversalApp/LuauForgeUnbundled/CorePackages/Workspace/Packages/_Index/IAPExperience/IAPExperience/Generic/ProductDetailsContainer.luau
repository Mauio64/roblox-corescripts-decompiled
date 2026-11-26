local React = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/React")

local view = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Foundation").View

local UnifiedProductDetails = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/UnifiedProductDetails")
local PriceSummaryV2 = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/PriceSummaryV2")
local module4 = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/DiscountSummary")
local multiItemPriceShowsDiscountAccordion = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/multiItemPriceShowsDiscountAccordion")

local UnifiedPurchaseModalTypeEnum = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Enums/UnifiedPurchaseModalTypeEnum")
require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/ProductPurchase/PricingTypes")
require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Enums/VirtualItemBadgeType")

local fFlagLuaAppsEnablePromptVIPServerPurchase = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/SharedFlags").FFlagLuaAppsEnablePromptVIPServerPurchase

local function itemPriceHasDiscountBreakdown(p2): boolean
	if not p2 then
		return false
	end

	local basePriceInRobux = p2.basePriceInRobux
	local priceInRobux = p2.priceInRobux

	return typeof(basePriceInRobux) == "number"
		and typeof(priceInRobux) == "number"
		and priceInRobux < basePriceInRobux
end

local function ProductDetailsContainer(props)
	local itemPrice = props.product and props.product.itemPrice
	local v5

	if itemPrice then
		local basePriceInRobux = itemPrice.basePriceInRobux
		local priceInRobux = itemPrice.priceInRobux

		if typeof(basePriceInRobux) == "number" and typeof(priceInRobux) == "number" then
			v5 = priceInRobux < basePriceInRobux
		else
			v5 = false
		end
	else
		v5 = false
	end

	local v6 = multiItemPriceShowsDiscountAccordion(itemPrice)
	local udim = UDim2.new(1, 0, 0, 100)

	if props.purchaseModalType == UnifiedPurchaseModalTypeEnum.MultiItem then
		if multiItemPriceShowsDiscountAccordion(itemPrice) then
			local createElement = React.createElement
			local v10

			if not props.hideProductDetails then
				local createElement2 = React.createElement
				local v12 = {
					layoutOrder = 1,
					isPortrait = false,
					isCompact = props.isCompact,
					itemIcon = props.product.itemIcon,
					itemName = props.product.itemName,
					itemRobuxCost = itemPrice.priceInRobux,
					itemPrice = itemPrice,
					model = props.product.model,
					subtitleView = props.subtitleView,
					itemDisplayPrice = props.product.itemDisplayPrice,
					isLoading = props.isLoading,
					priceSuffix = props.priceSuffix,
					includePriceSuffixOnOriginal = 0,
					priceText = 0
				}

				local v13 = if fFlagLuaAppsEnablePromptVIPServerPurchase then props.includePriceSuffixOnOriginal else nil
				v12.includePriceSuffixOnOriginal = v13

				local v14 = if fFlagLuaAppsEnablePromptVIPServerPurchase then props.priceText else nil
				v12.priceText = v14
				v10 = createElement2(UnifiedProductDetails, v12)
			end

			return createElement(
				view,
				{ tag = "col align-x-center align-y-top gap-medium size-full-0 auto-y" },
				{
					Details = v10,
					DiscountSummary = React.createElement(view, {
						tag = "size-full-0 auto-y padding-xxsmall",
						LayoutOrder = 2,
						Visible = not props.hideDiscountSummary
					}, {
						Discount = React.createElement(module4, {
							itemPrice = itemPrice,
							savingsSummary = props.savingsSummary
						})
					})
				}
			)
		elseif v5 then
			return React.createElement(
				view,
				{ tag = "col align-x-center align-y-top size-full-0", Size = udim },
				{
					Summary = React.createElement(PriceSummaryV2, {
						amount = props.product.itemRobuxCost,
						itemPrice = itemPrice,
						subtotalItemCount = props.subtotalItemCount
					})
				}
			)
		else
			return React.createElement(PriceSummaryV2, {
				amount = props.product.itemRobuxCost,
				itemPrice = itemPrice,
				subtotalItemCount = props.subtotalItemCount
			})
		end
	else
		local v7

		if itemPrice and v6 then
			v7 = React.createElement(view, {
				tag = "size-full-0 auto-y padding-xxsmall",
				LayoutOrder = 2,
				Visible = not props.hideDiscountSummary
			}, {
				Discount = React.createElement(module4, {
					itemPrice = itemPrice,
					savingsSummary = props.savingsSummary
				})
			})
		end

		if not v5 then
			v7 = nil
		end

		local createElement = React.createElement

		if not v6 then
			udim = nil
		end

		local createElement2 = React.createElement
		local v12 = {
			layoutOrder = 1,
			isPortrait = false,
			isCompact = props.isCompact,
			itemIcon = props.product.itemIcon,
			itemName = props.product.itemName,
			itemRobuxCost = props.product.itemRobuxCost,
			itemPrice = itemPrice,
			model = props.product.model,
			subtitleView = props.subtitleView,
			itemDisplayPrice = props.product.itemDisplayPrice,
			isLoading = props.isLoading,
			priceSuffix = props.priceSuffix,
			includePriceSuffixOnOriginal = 0,
			priceText = 0
		}

		local v13 = if fFlagLuaAppsEnablePromptVIPServerPurchase then props.includePriceSuffixOnOriginal else nil
		v12.includePriceSuffixOnOriginal = v13

		local v14 = if fFlagLuaAppsEnablePromptVIPServerPurchase then props.priceText else nil
		v12.priceText = v14
		return createElement(
			view,
			{
				tag = "col align-x-center align-y-top gap-medium size-full-0 auto-y",
				Size = udim
			},
			{ Details = createElement2(UnifiedProductDetails, v12), DiscountSummary = v7 }
		)
	end
end

return ProductDetailsContainer
