local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local PurchasePromptParent = PurchasePrompt.Parent
local Rodux = require(PurchasePromptParent.PurchasePromptDeps).Rodux
local SetPurchaseAnalyticsMetadata = require(PurchasePrompt.Actions.SetPurchaseAnalyticsMetadata)
local FFlagUnifiedPurchaseGamepassAddProductUniverseId = require(PurchasePromptParent.SharedFlags).FFlagUnifiedPurchaseGamepassAddProductUniverseId

return (Rodux.createReducer({}, {
	[SetPurchaseAnalyticsMetadata.name] = function(_, p2) -- line: 14
		-- upvalues: FFlagUnifiedPurchaseGamepassAddProductUniverseId (copy)
		return {
			purchaseFlowUUID = p2.purchaseAnalyticsMetadata.purchaseFlowUUID,
			surface = p2.purchaseAnalyticsMetadata.surface,
			productId = p2.purchaseAnalyticsMetadata.productId,
			productType = p2.purchaseAnalyticsMetadata.productType,
			productTargetId = p2.purchaseAnalyticsMetadata.productTargetId,
			saleLocationUniverseId = p2.purchaseAnalyticsMetadata.saleLocationUniverseId,
			productUniverseId = if not FFlagUnifiedPurchaseGamepassAddProductUniverseId then nil else p2.purchaseAnalyticsMetadata.productUniverseId,
			price = p2.purchaseAnalyticsMetadata.price,
			userRobuxBalance = p2.purchaseAnalyticsMetadata.userRobuxBalance,
			eventMetadata = p2.purchaseAnalyticsMetadata.eventMetadata
		}
	end
}))
