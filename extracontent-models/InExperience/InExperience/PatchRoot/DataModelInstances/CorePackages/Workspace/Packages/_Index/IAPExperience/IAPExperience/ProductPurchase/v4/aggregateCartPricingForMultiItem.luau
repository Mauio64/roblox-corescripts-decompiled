local cartPricingResponseLineItem = require(script.Parent.cartPricingResponseLineItem)

local function aggregateCartPricingForMultiItem(p1) -- line: 20
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

	for _, v in ipairs(items) do
		local v10 = cartPricingResponseLineItem.getCartLineSalePriceInRobux(v)

		if v10 == nil then
			return nil
		end

		n1 += cartPricingResponseLineItem.getCartLineRegularPriceInRobux(v, v10)
		n2 += v10
	end

	local v11 = n1 - n2

	if v11 <= 0 then
		return nil
	end

	return {
		subtotalRobux = n1,
		totalRobux = n2,
		savingsRobux = v11,
		itemCount = #items
	}
end

return aggregateCartPricingForMultiItem
