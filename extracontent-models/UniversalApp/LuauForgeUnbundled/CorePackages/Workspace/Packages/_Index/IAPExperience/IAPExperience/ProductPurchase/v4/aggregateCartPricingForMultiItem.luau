local cartPricingResponseLineItem = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/ProductPurchase/v4/cartPricingResponseLineItem")

local function aggregateCartPricingForMultiItem(p2)
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

	for i, item in ipairs(items) do
		local cartLineSalePriceInRobux = cartPricingResponseLineItem.getCartLineSalePriceInRobux(item)

		if cartLineSalePriceInRobux == nil then
			return nil
		end

		total += cartPricingResponseLineItem.getCartLineRegularPriceInRobux(item, cartLineSalePriceInRobux)
		total2 += cartLineSalePriceInRobux
	end

	local v5 = total - total2

	if v5 <= 0 then
		return nil
	end

	return {
		subtotalRobux = total,
		totalRobux = total2,
		savingsRobux = v5,
		itemCount = #items
	}
end

return aggregateCartPricingForMultiItem
