local cartPricingResponseLineItem = require(script.Parent.cartPricingResponseLineItem)

require(script.Parent.Parent.PricingTypes)

local function deriveCartPricingView(p1) -- line: 38
	-- upvalues: cartPricingResponseLineItem (copy)
	if type(p1) ~= "table" then
		return nil
	end

	local errors = p1.errors

	if type(errors) == "table" and next(errors) ~= nil then
		return nil
	end

	local items = p1.items

	if type(items) ~= "table" or next(items) == nil then
		return nil
	end

	local n1 = 0
	local n2 = 0

	for _, v9 in items do
		local v10 = cartPricingResponseLineItem.getCartLineSalePriceInRobux(v9)

		if v10 == nil then
			return nil
		end

		n1 += v10
		n2 += cartPricingResponseLineItem.getCartLineRegularPriceInRobux(v9, v10)
	end

	if n1 <= 0 then
		return nil
	end

	local v11 = cartPricingResponseLineItem.extractCartPricingMarketingOffers(p1)
	local t1 = {}

	for _, v14 in v11 do
		if v14.selected then
			table.insert(t1, v14.offerId)
		end
	end

	return {
		priceAfterDiscount = n1,
		originalPrice = n2,
		hasSavings = n1 < n2,
		itemCount = #items,
		discounts = cartPricingResponseLineItem.extractDiscountRowsFromLineItems(items),
		offers = v11,
		selectedOfferIds = t1,
		savingsSummary = cartPricingResponseLineItem.extractCartPricingSavingsSummary(p1)
	}
end

return deriveCartPricingView
