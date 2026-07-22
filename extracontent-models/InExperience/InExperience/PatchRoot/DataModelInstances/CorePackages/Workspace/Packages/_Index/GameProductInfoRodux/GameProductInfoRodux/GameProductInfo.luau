local Parent = script:FindFirstAncestor("GameProductInfoRodux").Parent
local Result = require(Parent.Result)
local v3 = game:DefineFastFlag("FixFiatPaidAccessPlayButton", false)
local t1 = {
	new = function() -- line: 20
		return {}
	end
}

function t1.mock(p1) -- line: 25
	-- upvalues: t1 (copy)
	local v6 = t1.new()

	v6.universeId = p1
	v6.isForSale = true
	v6.productId = 12345
	v6.price = 5
	v6.sellerId = 6789

	return v6
end
function t1.fromJsonData(p2) -- line: 35
	-- upvalues: v3 (copy), Result (copy), t1 (copy)
	local v8 = type(p2.universeId) == "number" and (type(p2.isForSale) == "boolean" and (type(p2.productId) == "number" and (type(p2.price) == "number" and type(p2.sellerId) == "number")))
	local v9 = if not v3 then nil else p2.fiatPurchaseData ~= nil and (type(p2.universeId) == "number" and type(p2.isForSale) == "boolean")

	if not v8 and not v9 then
		return Result.error("invalid data type")
	end

	local v10 = t1.new()

	v10.universeId = tostring(p2.universeId)
	v10.isForSale = p2.isForSale
	v10.productId = p2.productId
	v10.price = p2.price
	v10.sellerId = p2.sellerId

	if p2.fiatPurchaseData then
		v10.localizedFiatPrice = p2.fiatPurchaseData.localizedFiatPrice
		v10.fiatBasePriceId = p2.fiatPurchaseData.basePriceId
	end

	return Result.success(v10)
end

return t1
