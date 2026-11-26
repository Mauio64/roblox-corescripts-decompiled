local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)

return Rodux.makeActionCreator("UpdateLookDetailsAfterSuccessfulPurchase", function(p2, p3, p4, p5)
	return {
		lookId = p2,
		purchasedAssetIds = p3,
		purchasedBundleIds = p4,
		isOwnedAfterPurchase = p5
	}
end)
