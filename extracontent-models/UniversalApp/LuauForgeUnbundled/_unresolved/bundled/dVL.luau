local generateStringId = require("@game/CorePackages/Workspace/Packages/AppCommonLib").GenerateStringId

return {
	mock = function()
		return {
			["userAssetId"] = tostring(generateStringId()),
			userId = tostring(generateStringId()),
			userName = "",
			sellerHasVerifiedBadge = false,
			serialNumber = tostring(generateStringId()),
			priceInRobux = 0
		}
	end,
	fromSellPageAndResellers = function(data)
		local v5 = {}

		v5.userAssetId = tostring(data.userAssetId)

		if data.seller then
			v5.userId = tostring(data.seller.id)
			v5.userName = data.seller.name
			v5.sellerHasVerifiedBadge = data.seller.hasVerifiedBadge
		end

		local v6 = if data.serialNumber then tostring(data.serialNumber) or nil else nil
		v5.serialNumber = v6
		v5.priceInRobux = data.price
		v5.isOnHold = data.isOnHold
		return v5
	end,
	fromPriceInRobux = function(p2, p3)
		return { ["userAssetId"] = tostring(p2), priceInRobux = p3 }
	end
}
