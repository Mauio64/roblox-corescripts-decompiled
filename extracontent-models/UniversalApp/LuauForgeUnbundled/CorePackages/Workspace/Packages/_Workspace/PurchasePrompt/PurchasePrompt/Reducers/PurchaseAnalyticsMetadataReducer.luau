local rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePromptDeps").Rodux

local SetPurchaseAnalyticsMetadata = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/SetPurchaseAnalyticsMetadata")
local CompleteRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/CompleteRequest")
local fFlagPassShopPurchaseSurfaceToBuyModal = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/SharedFlags").FFlagPassShopPurchaseSurfaceToBuyModal

local v5 = {}

return (rodux.createReducer(v5, {
	[SetPurchaseAnalyticsMetadata.name] = function(p2, p3)
		return {
			purchaseFlowUUID = p3.purchaseAnalyticsMetadata.purchaseFlowUUID,
			surface = p3.purchaseAnalyticsMetadata.surface,
			productId = p3.purchaseAnalyticsMetadata.productId,
			productType = p3.purchaseAnalyticsMetadata.productType,
			productTargetId = p3.purchaseAnalyticsMetadata.productTargetId,
			saleLocationUniverseId = p3.purchaseAnalyticsMetadata.saleLocationUniverseId,
			productUniverseId = p3.purchaseAnalyticsMetadata.productUniverseId,
			price = p3.purchaseAnalyticsMetadata.price,
			userRobuxBalance = p3.purchaseAnalyticsMetadata.userRobuxBalance,
			eventMetadata = p3.purchaseAnalyticsMetadata.eventMetadata
		}
	end,
	[CompleteRequest.name] = function(p2, p3)
		if fFlagPassShopPurchaseSurfaceToBuyModal then
			return v5
		end

		return p2
	end
}))
