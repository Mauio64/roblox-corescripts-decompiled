local Parent = script:FindFirstAncestor("DiscoveryMonolith").Parent
local Result = require(Parent.Result)
local t1 = {
	new = function() -- line: 26
		return {}
	end
}

function t1.mock() -- line: 32
	-- upvalues: t1 (copy)
	local v4 = t1.new()

	v4.creatorId = 1
	v4.creatorName = "Roblox"
	v4.creatorType = "User"
	v4.itemRestrictions = {}
	v4.itemStatus = {}
	v4.lowestPrice = 1
	v4.name = "Serena"
	v4.noPriceStatus = "Free"
	v4.numberRemaining = 10
	v4.premiumPricing = {
		premiumPriceInRobux = 0
	}
	v4.priceInRobux = 0

	return v4
end
function t1.fromJsonData(p1) -- line: 52
	-- upvalues: t1 (copy), Result (copy)
	local v6 = t1.new()

	v6.creatorId = p1.creatorId
	v6.creatorName = p1.creatorName
	v6.creatorType = p1.creatorType
	v6.itemRestrictions = p1.itemRestrictions
	v6.itemStatus = p1.itemStatus
	v6.lowestPrice = p1.lowestPrice
	v6.name = p1.name
	v6.noPriceStatus = p1.noPriceStatus
	v6.numberRemaining = p1.numberRemaining
	v6.premiumPricing = p1.premiumPrice and {
		premiumPriceInRobux = p1.premiumPrice
	} or nil
	v6.priceInRobux = p1.price

	return Result.success(v6)
end

return t1
