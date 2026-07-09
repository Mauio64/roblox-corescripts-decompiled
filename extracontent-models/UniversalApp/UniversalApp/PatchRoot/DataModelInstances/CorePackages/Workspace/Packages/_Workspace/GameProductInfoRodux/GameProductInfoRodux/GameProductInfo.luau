local Parent = script:FindFirstAncestor("GameProductInfoRodux").Parent
local Result = require(Parent.Result)
local t1 = {
	new = function() -- line: 18
		return {}
	end
}

function t1.mock(p1) -- line: 23
	-- upvalues: t1 (copy)
	local v5 = t1.new()

	v5.universeId = p1
	v5.isForSale = true
	v5.productId = 12345
	v5.price = 5
	v5.sellerId = 6789

	return v5
end
function t1.fromJsonData(p2) -- line: 33
	-- upvalues: Result (copy), t1 (copy)
	if type(p2.universeId) ~= "number" or (type(p2.isForSale) ~= "boolean" or type(p2.productId) ~= "number" or type(p2.price) ~= "number" or type(p2.sellerId) ~= "number") then
		return Result.error("invalid data type")
	end

	local v7 = t1.new()

	v7.universeId = tostring(p2.universeId)
	v7.isForSale = p2.isForSale
	v7.productId = p2.productId
	v7.price = p2.price
	v7.sellerId = p2.sellerId

	if p2.fiatPurchaseData then
		v7.localizedFiatPrice = p2.fiatPurchaseData.localizedFiatPrice
		v7.fiatBasePriceId = p2.fiatPurchaseData.basePriceId
	end

	return Result.success(v7)
end

return t1
