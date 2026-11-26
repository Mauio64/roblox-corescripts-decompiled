local module = require("@luauforge/bundled/dtB")

local v5 = {}

function v5.new()
	return {}
end

function v5.mock()
	local v6 = v5.new()

	v6.creatorId = 1
	v6.creatorName = "Roblox"
	v6.creatorType = "User"
	v6.itemRestrictions = {}
	v6.itemStatus = {}
	v6.lowestPrice = 1
	v6.name = "Wings of Fire - Zara Larsson"
	v6.noPriceStatus = "nopriceStatus"
	v6.numberRemaining = 10
	v6.premiumPricing = { premiumPriceInRobux = 5 }

	v6.priceInRobux = 115

	return v6
end

function v5.fromJsonData(data)
	local v6 = v5.new()

	v6.creatorId = data.creatorId
	v6.creatorName = data.creatorName
	v6.creatorType = data.creatorType
	v6.itemRestrictions = data.itemRestrictions
	v6.itemStatus = data.itemStatus
	v6.lowestPrice = data.lowestPrice
	v6.name = data.name
	v6.noPriceStatus = data.noPriceStatus
	v6.numberRemaining = data.numberRemaining
	v6.premiumPricing = data.premiumPrice and ({
		premiumPriceInRobux = data.premiumPrice
	} or nil) or nil

	v6.priceInRobux = data.price

	return module.success(v6)
end

return v5
