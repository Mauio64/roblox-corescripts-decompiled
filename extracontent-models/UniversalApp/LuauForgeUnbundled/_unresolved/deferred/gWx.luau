require("@luauforge/bundled/gIl")

local default = require("@luauforge/bundled/gWy").PaymentsProtocol.default

local v5 = {}

function LUAUFORGE_MODULE_GLOBALS_gWx_calculateMoreAmount(list)
	if list == nil or #list == 0 then
		return {}
	end

	local v6 = nil

	for k, item in list do
		if v6 == nil or item.robuxAmount < v6.robuxAmount then
			v6 = item
		end
	end

	for k, item in list do
		local v7 = item.robuxAmount - v6.robuxAmount * (item.price / v6.price)

		if v7 > 0 then
			item.robuxMoreAmount = math.floor((v7 + 50) / 100) * 100
		end
	end

	return list
end

function v5.formatIapProducts(items)
	local v6 = {}

	for k, item in items do
		table.insert(v6, {
			productId = item.productId,
			price = item.price,
			packageId = item.mobileProductId,
			robuxAmount = item.robuxAmount,
			currencyAmountStr = item.currencySymbol .. tostring(item.price)
		})
	end

	return LUAUFORGE_MODULE_GLOBALS_gWx_calculateMoreAmount(v6)
end

function v5.formatNativeRobuxProducts(items)
	local v6 = {}

	for k, item in items do
		table.insert(v6, {
			productId = item.productId,
			price = item.price,
			packageId = item.nativeProductId,
			robuxAmount = item.robuxAmount,
			currencyAmountStr = item.displayPrice
		})
	end

	return LUAUFORGE_MODULE_GLOBALS_gWx_calculateMoreAmount(v6)
end

return v5
