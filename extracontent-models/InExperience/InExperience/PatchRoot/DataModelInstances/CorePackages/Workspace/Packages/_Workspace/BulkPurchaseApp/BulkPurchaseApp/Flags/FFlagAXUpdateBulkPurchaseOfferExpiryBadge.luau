local BulkPurchaseApp = script:FindFirstAncestor("BulkPurchaseApp")
local FFlagAXAddOffersToBulkPurchase = require(BulkPurchaseApp.Flags.FFlagAXAddOffersToBulkPurchase)

return game:DefineFastFlag("AXUpdateBulkPurchaseOfferExpiryBadge", false) and FFlagAXAddOffersToBulkPurchase
