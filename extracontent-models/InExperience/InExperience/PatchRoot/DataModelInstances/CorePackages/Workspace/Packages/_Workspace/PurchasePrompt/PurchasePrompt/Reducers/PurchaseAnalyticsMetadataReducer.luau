local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local parent = PurchasePrompt.Parent

local PurchasePromptDeps = require(parent.PurchasePromptDeps)
local Rodux = PurchasePromptDeps.Rodux

local SetPurchaseAnalyticsMetadata = require(PurchasePrompt.Actions.SetPurchaseAnalyticsMetadata)
local CompleteRequest = require(PurchasePrompt.Actions.CompleteRequest)
local SharedFlags = require(parent.SharedFlags)
local FFlagPassShopPurchaseSurfaceToBuyModal = SharedFlags.FFlagPassShopPurchaseSurfaceToBuyModal

local v = {}

return (Rodux.createReducer(v, {
	[SetPurchaseAnalyticsMetadata.name] = function(_, p)
		return {
			purchaseFlowUUID = p.purchaseAnalyticsMetadata.purchaseFlowUUID,
			surface = p.purchaseAnalyticsMetadata.surface,
			productId = p.purchaseAnalyticsMetadata.productId,
			productType = p.purchaseAnalyticsMetadata.productType,
			productTargetId = p.purchaseAnalyticsMetadata.productTargetId,
			saleLocationUniverseId = p.purchaseAnalyticsMetadata.saleLocationUniverseId,
			productUniverseId = p.purchaseAnalyticsMetadata.productUniverseId,
			price = p.purchaseAnalyticsMetadata.price,
			userRobuxBalance = p.purchaseAnalyticsMetadata.userRobuxBalance,
			eventMetadata = p.purchaseAnalyticsMetadata.eventMetadata
		}
	end,
	[CompleteRequest.name] = function(p, _)
		if FFlagPassShopPurchaseSurfaceToBuyModal then
			return v
		end

		return p
	end
}))
