local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local parent = PurchasePrompt.Parent

local PurchasePromptDeps = require(parent.PurchasePromptDeps)
local Rodux = PurchasePromptDeps.Rodux

local SetPurchaseCallbacks = require(PurchasePrompt.Actions.SetPurchaseCallbacks)

local SharedFlags = require(PurchasePrompt.Parent.SharedFlags)
local FFlagAddOnRobloxSubscriptionUpsellSuccessCallbackToUnifiedPurchaseModal = SharedFlags.FFlagAddOnRobloxSubscriptionUpsellSuccessCallbackToUnifiedPurchaseModal
local SharedFlags2 = require(PurchasePrompt.Parent.SharedFlags)
local FFlagEnableLaunchAfterPurchase = SharedFlags2.FFlagEnableLaunchAfterPurchase

return (Rodux.createReducer({}, {
	[SetPurchaseCallbacks.name] = function(_, p)
		local v = {
			onFlowComplete = p.purchaseCallbacks.onFlowComplete,
			onPurchaseSuccess = p.purchaseCallbacks.onPurchaseSuccess,
			onBuyItemButtonMounted = p.purchaseCallbacks.onBuyItemButtonMounted,
			onPurchaseAttempt = p.purchaseCallbacks.onPurchaseAttempt,
			onRobloxSubscriptionUpsellSuccess = 0,
			fetchProductInfo = 0,
			onLaunchAfterPurchase = 0
		}
		local onRobloxSubscriptionUpsellSuccess

		if FFlagAddOnRobloxSubscriptionUpsellSuccessCallbackToUnifiedPurchaseModal then
			onRobloxSubscriptionUpsellSuccess = p.purchaseCallbacks.onRobloxSubscriptionUpsellSuccess
		end

		v.onRobloxSubscriptionUpsellSuccess = onRobloxSubscriptionUpsellSuccess

		v.fetchProductInfo = p.purchaseCallbacks.fetchProductInfo
		local onLaunchAfterPurchase

		if FFlagEnableLaunchAfterPurchase then
			onLaunchAfterPurchase = p.purchaseCallbacks.onLaunchAfterPurchase
		end

		v.onLaunchAfterPurchase = onLaunchAfterPurchase
		return v
	end
}))
