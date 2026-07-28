local IAPExperience = script:FindFirstAncestor("IAPExperience")
local IAPExperienceParent = IAPExperience.Parent
local React = require(IAPExperienceParent.React)
local View = require(IAPExperienceParent.Foundation).View
local UnifiedProductDetails = require(IAPExperience.Generic.UnifiedProductDetails)
local PriceSummaryV2 = require(IAPExperience.Generic.PriceSummaryV2)
local DiscountSummary = require(IAPExperience.Generic.DiscountSummary)
local multiItemPriceShowsDiscountAccordion = require(IAPExperience.Generic.multiItemPriceShowsDiscountAccordion)
local UnifiedPurchaseModalTypeEnum = require(IAPExperience.Enums.UnifiedPurchaseModalTypeEnum)

require(IAPExperience.ProductPurchase.PricingTypes)
require(IAPExperience.Enums.VirtualItemBadgeType)

local FFlagPurchasePromptFetchCartPricing = require(IAPExperienceParent.SharedFlags).FFlagPurchasePromptFetchCartPricing

local function itemPriceHasDiscountBreakdown(p1) -- line: 60
	if not p1 then
		return false
	end

	local basePriceInRobux = p1.basePriceInRobux
	local priceInRobux = p1.priceInRobux

	return typeof(basePriceInRobux) == "number" and (typeof(priceInRobux) == "number" and priceInRobux < basePriceInRobux)
end
local function ProductDetailsContainer(t1: {[any]: any}) -- line: 71
	-- upvalues: FFlagPurchasePromptFetchCartPricing (copy), multiItemPriceShowsDiscountAccordion (copy), UnifiedPurchaseModalTypeEnum (copy), React (copy), View (copy), UnifiedProductDetails (copy), DiscountSummary (copy), PriceSummaryV2 (copy)
	local v17 = t1.product and t1.product.itemPrice
	local v18

	if not v17 then
		v18 = false
	else
		local basePriceInRobux = v17.basePriceInRobux
		local priceInRobux = v17.priceInRobux

		v18 = typeof(basePriceInRobux) == "number" and (typeof(priceInRobux) == "number" and priceInRobux < basePriceInRobux)
	end

	local v21 = nil

	if FFlagPurchasePromptFetchCartPricing then
		v21 = multiItemPriceShowsDiscountAccordion(v17)
	end

	local uDim2 = UDim2.new(1, 0, 0, 100)

	if t1.purchaseModalType == UnifiedPurchaseModalTypeEnum.MultiItem then
		if FFlagPurchasePromptFetchCartPricing and multiItemPriceShowsDiscountAccordion(v17) then
			return React.createElement(View, {
				tag = "col align-x-center align-y-top gap-medium size-full-0 auto-y"
			}, {
				Details = if not t1.hideProductDetails then React.createElement(UnifiedProductDetails, {
					layoutOrder = 1,
					isPortrait = false,
					isCompact = t1.isCompact,
					itemIcon = t1.product.itemIcon,
					itemName = t1.product.itemName,
					itemRobuxCost = v17.priceInRobux,
					itemPrice = v17,
					model = t1.product.model,
					subtitleView = t1.subtitleView,
					itemDisplayPrice = t1.product.itemDisplayPrice,
					isLoading = t1.isLoading,
					priceSuffix = t1.priceSuffix
				}) else nil,
				DiscountSummary = React.createElement(View, {
					tag = "size-full-0 auto-y padding-xxsmall",
					LayoutOrder = 2,
					Visible = not t1.hideDiscountSummary
				}, {
					Discount = React.createElement(DiscountSummary, {
						itemPrice = v17,
						savingsSummary = t1.savingsSummary
					})
				})
			})
		end

		if v18 then
			return React.createElement(View, {
				tag = {
					["col align-x-center align-y-top size-full-0"] = FFlagPurchasePromptFetchCartPricing,
					["col shrink-0 size-full-0 align-x-center align-y-start"] = not FFlagPurchasePromptFetchCartPricing
				},
				Size = uDim2
			}, {
				Summary = React.createElement(PriceSummaryV2, {
					amount = t1.product.itemRobuxCost,
					itemPrice = v17,
					subtotalItemCount = if not FFlagPurchasePromptFetchCartPricing then nil else t1.subtotalItemCount
				})
			})
		end

		return (React.createElement(PriceSummaryV2, {
			amount = t1.product.itemRobuxCost,
			itemPrice = v17,
			subtotalItemCount = if not FFlagPurchasePromptFetchCartPricing then nil else t1.subtotalItemCount
		}))
	end

	local v23 = if not v17 or not not FFlagPurchasePromptFetchCartPricing and not v21 then nil else React.createElement(View, {
		LayoutOrder = 2,
		tag = {
			["size-full-0 auto-y padding-xxsmall"] = FFlagPurchasePromptFetchCartPricing,
			["auto-y size-full-0 padding-xxsmall"] = not FFlagPurchasePromptFetchCartPricing
		},
		Visible = if not FFlagPurchasePromptFetchCartPricing then nil else not t1.hideDiscountSummary
	}, {
		Discount = React.createElement(DiscountSummary, {
			itemPrice = v17,
			savingsSummary = if not FFlagPurchasePromptFetchCartPricing then nil else t1.savingsSummary
		})
	})

	if not v18 then
		v23 = nil
	end

	return React.createElement(View, {
		tag = {
			["col align-x-center align-y-top gap-medium size-full-0 auto-y"] = FFlagPurchasePromptFetchCartPricing,
			["col gap-medium shrink-0 auto-y size-full-0 align-x-center align-y-start"] = not FFlagPurchasePromptFetchCartPricing and v18,
			["col gap-medium auto-y size-full-0 align-x-center align-y-start"] = not FFlagPurchasePromptFetchCartPricing and not v18
		},
		Size = if not if not FFlagPurchasePromptFetchCartPricing then v18 else v21 then nil else uDim2
	}, {
		Details = React.createElement(UnifiedProductDetails, {
			layoutOrder = 1,
			isPortrait = false,
			isCompact = t1.isCompact,
			itemIcon = t1.product.itemIcon,
			itemName = t1.product.itemName,
			itemRobuxCost = t1.product.itemRobuxCost,
			itemPrice = v17,
			model = t1.product.model,
			subtitleView = t1.subtitleView,
			itemDisplayPrice = t1.product.itemDisplayPrice,
			isLoading = t1.isLoading,
			priceSuffix = t1.priceSuffix
		}),
		DiscountSummary = v23
	})
end

return ProductDetailsContainer
