local IAPExperience = script:FindFirstAncestor("IAPExperience")
local cartPricingResponseLineItem = require(script.Parent.cartPricingResponseLineItem)

local SharedFlags = require(IAPExperience.Parent.SharedFlags)
local FFlagPurchasePromptFetchCartPricingForLooks = SharedFlags.FFlagPurchasePromptFetchCartPricingForLooks
local defineFastFlag = game:DefineFastFlag("AXAllowFreeItemsFromOffer", false)

require(script.Parent.Parent.PricingTypes)

local function deriveCartPricingView(p)
	if type(p) ~= "table" then
		return nil
	end

	local errors = p.errors

	if type(errors) == "table" and next(errors) ~= nil then
		return nil
	end

	local items = p.items

	if type(items) ~= "table" or next(items) == nil then
		return nil
	end

	local total = 0
	local total2 = 0

	for _, item in items do
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

	local cartPricingMarketingOffers = cartPricingResponseLineItem.extractCartPricingMarketingOffers(p)
	local offerIds = {}

	for _, cartPricingMarketingOffer in cartPricingMarketingOffers do
		if cartPricingMarketingOffer.selected then
			table.insert(offerIds, cartPricingMarketingOffer.offerId)
		end
	end

	local discounts

	if FFlagPurchasePromptFetchCartPricingForLooks then
		local discountRowsFromLineItems = cartPricingResponseLineItem.extractDiscountRowsFromLineItems(items)
		discounts = cartPricingResponseLineItem.consolidateRobloxPlusDiscounts(discountRowsFromLineItems)
	end

	local v = {
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

	if not FFlagPurchasePromptFetchCartPricingForLooks then
		discounts = cartPricingResponseLineItem.extractDiscountRowsFromLineItems(items)
	end

	v.discounts = discounts

	v.offers = cartPricingMarketingOffers
	v.selectedOfferIds = offerIds
	v.savingsSummary = cartPricingResponseLineItem.extractCartPricingSavingsSummary(p)
	return v
end

return deriveCartPricingView
