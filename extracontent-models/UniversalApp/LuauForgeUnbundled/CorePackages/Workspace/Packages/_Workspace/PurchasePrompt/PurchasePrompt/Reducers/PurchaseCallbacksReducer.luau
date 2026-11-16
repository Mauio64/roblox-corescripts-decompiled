local rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePromptDeps").Rodux

local SetPurchaseCallbacks = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/SetPurchaseCallbacks")

local fFlagAddOnRobloxSubscriptionUpsellSuccessCallbackToUnifiedPurchaseModal = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/SharedFlags").FFlagAddOnRobloxSubscriptionUpsellSuccessCallbackToUnifiedPurchaseModal
local fFlagEnableLaunchAfterPurchase = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/SharedFlags").FFlagEnableLaunchAfterPurchase

return (rodux.createReducer({}, {
	[SetPurchaseCallbacks.name] = function(p2, p3)
		local v6 = {
			onFlowComplete = p3.purchaseCallbacks.onFlowComplete,
			onPurchaseSuccess = p3.purchaseCallbacks.onPurchaseSuccess,
			onBuyItemButtonMounted = p3.purchaseCallbacks.onBuyItemButtonMounted,
			onPurchaseAttempt = p3.purchaseCallbacks.onPurchaseAttempt,
			onRobloxSubscriptionUpsellSuccess = 0,
			fetchProductInfo = 0,
			onLaunchAfterPurchase = 0
		}

		local v7 = if fFlagAddOnRobloxSubscriptionUpsellSuccessCallbackToUnifiedPurchaseModal then p3.purchaseCallbacks.onRobloxSubscriptionUpsellSuccess else nil
		v6.onRobloxSubscriptionUpsellSuccess = v7

		v6.fetchProductInfo = p3.purchaseCallbacks.fetchProductInfo

		local v8 = if fFlagEnableLaunchAfterPurchase then p3.purchaseCallbacks.onLaunchAfterPurchase else nil
		v6.onLaunchAfterPurchase = v8
		return v6
	end
}))
