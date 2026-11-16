local Result = require("@game/CorePackages/Workspace/Packages/_Workspace/GameProductInfoRodux/Result")

local v5 = {}

function v5.new()
	return {}
end

function v5.mock(universeId)
	local v6 = v5.new()
	v6.universeId = universeId
	v6.isForSale = true
	v6.productId = 12345
	v6.price = 5
	v6.sellerId = 6789
	return v6
end

function v5.fromJsonData(data)
	local v6

	if
		type(data.universeId) == "number"
		and type(data.isForSale) == "boolean"
		and type(data.productId) == "number"
		and type(data.price) == "number"
	then
		v6 = type(data.sellerId) == "number"
	else
		v6 = false
	end

	local v7

	if data.fiatPurchaseData == nil or type(data.universeId) ~= "number" then
		v7 = false
	else
		v7 = type(data.isForSale) == "boolean"
	end

	if not (v6 or v7) then
		return Result.error("invalid data type")
	end

	local v8 = v5.new()
	v8.universeId = tostring(data.universeId)
	v8.isForSale = data.isForSale
	v8.productId = data.productId
	v8.price = data.price
	v8.sellerId = data.sellerId

	if data.fiatPurchaseData then
		v8.localizedFiatPrice = data.fiatPurchaseData.localizedFiatPrice
		v8.fiatBasePriceId = data.fiatPurchaseData.basePriceId
	end

	return Result.success(v8)
end

return v5
