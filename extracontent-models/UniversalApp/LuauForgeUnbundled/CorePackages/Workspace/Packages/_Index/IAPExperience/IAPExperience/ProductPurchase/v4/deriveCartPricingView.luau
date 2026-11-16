local cartPricingResponseLineItem = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/ProductPurchase/v4/cartPricingResponseLineItem")

local fFlagPurchasePromptFetchCartPricingForLooks = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/SharedFlags").FFlagPurchasePromptFetchCartPricingForLooks
local defineFastFlag = game:DefineFastFlag("AXAllowFreeItemsFromOffer", false)

require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/ProductPurchase/PricingTypes")

local function deriveCartPricingView(p2)
	if type(p2) ~= "table" then
		return nil
	end

	local errors = p2.errors

	if type(errors) == "table" and next(errors) ~= nil then
		return nil
	end

	local items = p2.items

	if type(items) ~= "table" or next(items) == nil then
		return nil
	end

	local total = 0
	local total2 = 0

	for k, item in items do
		local cartLineSalePriceInRobux = cartPricingResponseLineItem.getCartLineSalePriceInRobux(item)

		if cartLineSalePriceInRobux == nil then
			return nil
		end

		total += cartLineSalePriceInRobux
		total2 += cartPricingResponseLineItem.getCartLineRegularPriceInRobux(item, cartLineSalePriceInRobux)
	end

	if not defineFastFlag and total <= 0 or defineFastFlag and total < 0 then
		return nil
	end

	local cartPricingMarketingOffers = cartPricingResponseLineItem.extractCartPricingMarketingOffers(p2)
	local offerIds = {}

	for k, cartPricingMarketingOffer in cartPricingMarketingOffers do
		if cartPricingMarketingOffer.selected then
			table.insert(offerIds, cartPricingMarketingOffer.offerId)
		end
	end

	local v5

	if fFlagPurchasePromptFetchCartPricingForLooks then
		local discountRowsFromLineItems = cartPricingResponseLineItem.extractDiscountRowsFromLineItems(items)
		v5 = cartPricingResponseLineItem.consolidateRobloxPlusDiscounts(discountRowsFromLineItems)
	end

	local v6 = {
		priceAfterDiscount = total,
		originalPrice = total2,
		priceWithoutOffersDiscounts = cartPricingResponseLineItem.computePriceWithoutOffersDiscounts(items, total),
		hasSavings = total < total2,
		itemCount = #items,
		discounts = 0,
		offers = 0,
		selectedOfferIds = 0,
		savingsSummary = 0
	}

	if not fFlagPurchasePromptFetchCartPricingForLooks then
		v5 = cartPricingResponseLineItem.extractDiscountRowsFromLineItems(items)
	end

	v6.discounts = v5

	v6.offers = cartPricingMarketingOffers
	v6.selectedOfferIds = offerIds
	v6.savingsSummary = cartPricingResponseLineItem.extractCartPricingSavingsSummary(p2)
	return v6
end

return deriveCartPricingView
