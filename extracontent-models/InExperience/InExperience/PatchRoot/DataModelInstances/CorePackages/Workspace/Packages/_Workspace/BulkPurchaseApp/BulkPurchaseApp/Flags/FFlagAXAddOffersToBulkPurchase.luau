local BulkPurchaseApp = script:FindFirstAncestor("BulkPurchaseApp")
local FFlagAXAddPlusUpsellToBulkPurchase = require(BulkPurchaseApp.Flags.FFlagAXAddPlusUpsellToBulkPurchase)

return game:DefineFastFlag("AXAddOffersToBulkPurchase", false)
	and FFlagAXAddPlusUpsellToBulkPurchase
	and game:GetEngineFeature("PromptBulkPurchaseRequestedV3EventEnabled")
	and game:GetEngineFeature("BulkPurchaseOffersEnabled")
