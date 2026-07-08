local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local PurchasePromptParent = PurchasePrompt.Parent
local Rodux = require(PurchasePromptParent.PurchasePromptDeps).Rodux
local SetPurchaseCallbacks = require(PurchasePrompt.Actions.SetPurchaseCallbacks)
local FFlagAddFetchProductInfoAsACallback = require(PurchasePrompt.Parent.SharedFlags).FFlagAddFetchProductInfoAsACallback
local FFlagAddOnRobloxSubscriptionUpsellSuccessCallbackToUnifiedPurchaseModal = require(PurchasePrompt.Parent.SharedFlags).FFlagAddOnRobloxSubscriptionUpsellSuccessCallbackToUnifiedPurchaseModal

return (Rodux.createReducer({}, {
	[SetPurchaseCallbacks.name] = function(_, p2) -- line: 13
		-- upvalues: FFlagAddOnRobloxSubscriptionUpsellSuccessCallbackToUnifiedPurchaseModal (copy), FFlagAddFetchProductInfoAsACallback (copy)
		return {
			onFlowComplete = p2.purchaseCallbacks.onFlowComplete,
			onPurchaseSuccess = p2.purchaseCallbacks.onPurchaseSuccess,
			onBuyItemButtonMounted = p2.purchaseCallbacks.onBuyItemButtonMounted,
			onPurchaseAttempt = p2.purchaseCallbacks.onPurchaseAttempt,
			onRobloxSubscriptionUpsellSuccess = if not FFlagAddOnRobloxSubscriptionUpsellSuccessCallbackToUnifiedPurchaseModal then nil else p2.purchaseCallbacks.onRobloxSubscriptionUpsellSuccess,
			fetchProductInfo = if not FFlagAddFetchProductInfoAsACallback then nil else p2.purchaseCallbacks.fetchProductInfo
		}
	end
}))
