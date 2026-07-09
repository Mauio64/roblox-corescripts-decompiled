local CorePackages = game:GetService("CorePackages")
local t = require(CorePackages.Packages.t)

return {
	PurchaseDetail = t.strictInterface({
		expectedCurrency = t.optional(t.integer),
		expectedPrice = t.optional(t.integer),
		expectedSellerId = t.optional(t.integer),
		expectedPromoId = t.optional(t.integer),
		userAssetId = t.optional(t.integer),
		saleLocationType = t.optional(t.union(t.literal("Website"), t.literal("Game"))),
		saleLocationId = t.optional(t.string)
	})
}
