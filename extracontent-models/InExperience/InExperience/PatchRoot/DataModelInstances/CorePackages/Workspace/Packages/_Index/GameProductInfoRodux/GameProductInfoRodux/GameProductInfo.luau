local parent = script:FindFirstAncestor("GameProductInfoRodux").Parent
local Result = require(parent.Result)

local GameProductInfo = {}

function GameProductInfo.new()
	return {}
end

function GameProductInfo.mock(universeId)
	local v = GameProductInfo.new()
	v.universeId = universeId
	v.isForSale = true
	v.productId = 12345
	v.price = 5
	v.sellerId = 6789
	return v
end

function GameProductInfo.fromJsonData(data)
	local v

	if
		type(data.universeId) == "number"
		and type(data.isForSale) == "boolean"
		and type(data.productId) == "number"
		and type(data.price) == "number"
	then
		v = type(data.sellerId) == "number"
	else
		v = false
	end

	local v2

	if data.fiatPurchaseData == nil or type(data.universeId) ~= "number" then
		v2 = false
	else
		v2 = type(data.isForSale) == "boolean"
	end

	if not (v or v2) then
		return Result.error("invalid data type")
	end

	local v3 = GameProductInfo.new()
	v3.universeId = tostring(data.universeId)
	v3.isForSale = data.isForSale
	v3.productId = data.productId
	v3.price = data.price
	v3.sellerId = data.sellerId

	if data.fiatPurchaseData then
		v3.localizedFiatPrice = data.fiatPurchaseData.localizedFiatPrice
		v3.fiatBasePriceId = data.fiatPurchaseData.basePriceId
	end

	return Result.success(v3)
end

return GameProductInfo
