local cartPricingResponseLineItem = require(script.Parent.cartPricingResponseLineItem)

local function aggregateCartPricingForMultiItem(p)
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

	for _, item in ipairs(items) do
		local cartLineSalePriceInRobux = cartPricingResponseLineItem.getCartLineSalePriceInRobux(item)

		if cartLineSalePriceInRobux == nil then
			return nil
		end

		total += cartPricingResponseLineItem.getCartLineRegularPriceInRobux(item, cartLineSalePriceInRobux)
		total2 += cartLineSalePriceInRobux
	end

	local savingsRobux = total - total2

	if savingsRobux <= 0 then
		return nil
	end

	return {
		subtotalRobux = total,
		totalRobux = total2,
		savingsRobux = savingsRobux,
		itemCount = #items
	}
end

return aggregateCartPricingForMultiItem
