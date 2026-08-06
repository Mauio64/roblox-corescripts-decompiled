local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local PurchasePromptParent = PurchasePrompt.Parent
local Rodux = require(PurchasePromptParent.PurchasePromptDeps).Rodux
local SetPurchaseAnalyticsMetadata = require(PurchasePrompt.Actions.SetPurchaseAnalyticsMetadata)
local CompleteRequest = require(PurchasePrompt.Actions.CompleteRequest)
local SharedFlags = require(PurchasePromptParent.SharedFlags)
local FFlagUnifiedPurchaseGamepassAddProductUniverseId = SharedFlags.FFlagUnifiedPurchaseGamepassAddProductUniverseId
local FFlagPassShopPurchaseSurfaceToBuyModal = SharedFlags.FFlagPassShopPurchaseSurfaceToBuyModal
local t1 = {}

return (Rodux.createReducer(t1, {
	[SetPurchaseAnalyticsMetadata.name] = function(_, p2) -- line: 18
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
	end,
	[CompleteRequest.name] = function(p3, _) -- line: 34
		-- upvalues: FFlagPassShopPurchaseSurfaceToBuyModal (copy), t1 (copy)
		if FFlagPassShopPurchaseSurfaceToBuyModal then
			return t1
		end

		return p3
	end
}))
