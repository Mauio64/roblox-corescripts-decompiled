local IAPExperience = script:FindFirstAncestor("IAPExperience")
local parent = IAPExperience.Parent

local React = require(parent.React)

local Foundation = require(parent.Foundation)
local View = Foundation.View

local UnifiedProductDetails = require(IAPExperience.Generic.UnifiedProductDetails)
local PriceSummaryV2 = require(IAPExperience.Generic.PriceSummaryV2)
local DiscountSummary = require(IAPExperience.Generic.DiscountSummary)
local multiItemPriceShowsDiscountAccordion = require(IAPExperience.Generic.multiItemPriceShowsDiscountAccordion)

local UnifiedPurchaseModalTypeEnum = require(IAPExperience.Enums.UnifiedPurchaseModalTypeEnum)
require(IAPExperience.ProductPurchase.PricingTypes)
require(IAPExperience.Enums.VirtualItemBadgeType)

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppsEnablePromptVIPServerPurchase = SharedFlags.FFlagLuaAppsEnablePromptVIPServerPurchase

local function itemPriceHasDiscountBreakdown(itemPrice): boolean -- 1 equivalent call inferred from this helper
	if not itemPrice then
		return false
	end

	local basePriceInRobux = itemPrice.basePriceInRobux
	local priceInRobux = itemPrice.priceInRobux

	return typeof(basePriceInRobux) == "number" and typeof(priceInRobux) == "number" and priceInRobux < basePriceInRobux
end

local function ProductDetailsContainer(props)
	local itemPrice = props.product and props.product.itemPrice
	local v = itemPriceHasDiscountBreakdown(itemPrice) -- inferred equivalent call
	local v2 = multiItemPriceShowsDiscountAccordion(itemPrice)
	local udim = UDim2.new(1, 0, 0, 100)

	if props.purchaseModalType == UnifiedPurchaseModalTypeEnum.MultiItem then
		if multiItemPriceShowsDiscountAccordion(itemPrice) then
			local createElement = React.createElement
			local details

			if not props.hideProductDetails then
				local createElement2 = React.createElement
				local v3 = {
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
				local includePriceSuffixOnOriginal

				if FFlagLuaAppsEnablePromptVIPServerPurchase then
					includePriceSuffixOnOriginal = props.includePriceSuffixOnOriginal
				end

				v3.includePriceSuffixOnOriginal = includePriceSuffixOnOriginal
				local priceText

				if FFlagLuaAppsEnablePromptVIPServerPurchase then
					priceText = props.priceText
				end

				v3.priceText = priceText
				details = createElement2(UnifiedProductDetails, v3)
			end

			return createElement(View, {
				tag = "col align-x-center align-y-top gap-medium size-full-0 auto-y"
			}, {
				Details = details,
				DiscountSummary = React.createElement(View, {
					tag = "size-full-0 auto-y padding-xxsmall",
					LayoutOrder = 2,
					Visible = not props.hideDiscountSummary
				}, {
					Discount = React.createElement(DiscountSummary, {
						itemPrice = itemPrice,
						savingsSummary = props.savingsSummary
					})
				})
			})
		elseif v then
			return React.createElement(View, {
				tag = "col align-x-center align-y-top size-full-0",
				Size = udim
			}, {
				Summary = React.createElement(PriceSummaryV2, {
					amount = props.product.itemRobuxCost,
					itemPrice = itemPrice,
					subtotalItemCount = props.subtotalItemCount
				})
			})
		else
			return (React.createElement(PriceSummaryV2, {
				amount = props.product.itemRobuxCost,
				itemPrice = itemPrice,
				subtotalItemCount = props.subtotalItemCount
			}))
		end
	else
		local discountSummary

		if itemPrice and v2 then
			discountSummary = React.createElement(View, {
				tag = "size-full-0 auto-y padding-xxsmall",
				LayoutOrder = 2,
				Visible = not props.hideDiscountSummary
			}, {
				Discount = React.createElement(DiscountSummary, {
					itemPrice = itemPrice,
					savingsSummary = props.savingsSummary
				})
			})
		end

		if not v then
			discountSummary = nil
		end

		local createElement = React.createElement

		if not v2 then
			udim = nil
		end

		local createElement2 = React.createElement
		local v3 = {
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
		local includePriceSuffixOnOriginal

		if FFlagLuaAppsEnablePromptVIPServerPurchase then
			includePriceSuffixOnOriginal = props.includePriceSuffixOnOriginal
		end

		v3.includePriceSuffixOnOriginal = includePriceSuffixOnOriginal
		local priceText

		if FFlagLuaAppsEnablePromptVIPServerPurchase then
			priceText = props.priceText
		end

		v3.priceText = priceText
		return createElement(
			View,
			{ tag = "col align-x-center align-y-top gap-medium size-full-0 auto-y", Size = udim },
			{
				Details = createElement2(UnifiedProductDetails, v3),
				DiscountSummary = discountSummary
			}
		)
	end
end

return ProductDetailsContainer
