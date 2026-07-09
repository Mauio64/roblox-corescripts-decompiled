local CorePackages = game:GetService("CorePackages")
local GenerateStringId = require(CorePackages.Workspace.Packages.AppCommonLib).GenerateStringId

return {
	mock = function() -- line: 27
		-- upvalues: GenerateStringId (copy)
		return {
			userAssetId = tostring(GenerateStringId()),
			userId = tostring(GenerateStringId()),
			userName = "",
			sellerHasVerifiedBadge = false,
			serialNumber = tostring(GenerateStringId()),
			priceInRobux = 0
		}
	end,
	fromSellPageAndResellers = function(p1) -- line: 40
		local t1 = {
			userAssetId = tostring(p1.userAssetId)
		}

		if p1.seller then
			t1.userId = tostring(p1.seller.id)
			t1.userName = p1.seller.name
			t1.sellerHasVerifiedBadge = p1.seller.hasVerifiedBadge
		end

		t1.serialNumber = p1.serialNumber and tostring(p1.serialNumber) or nil
		t1.priceInRobux = p1.price
		t1.isOnHold = p1.isOnHold

		return t1
	end,
	fromPriceInRobux = function(p2, p3) -- line: 56
		return {
			userAssetId = tostring(p2),
			priceInRobux = p3
		}
	end
}
