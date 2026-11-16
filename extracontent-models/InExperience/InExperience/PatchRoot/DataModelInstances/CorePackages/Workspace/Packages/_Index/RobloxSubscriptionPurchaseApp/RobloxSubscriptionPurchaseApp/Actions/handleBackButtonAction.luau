local RobloxSubscriptionPurchaseApp = script:FindFirstAncestor("RobloxSubscriptionPurchaseApp")

local RobloxSubscriptionStore = require(RobloxSubscriptionPurchaseApp.Store.RobloxSubscriptionStore)
local cleanupSubscriptionFlow = require(RobloxSubscriptionPurchaseApp.Actions.cleanupSubscriptionFlow)

local function handleBackButtonAction()
	RobloxSubscriptionStore.get().triggerOnBackButtonActivated()
	cleanupSubscriptionFlow()
end

return handleBackButtonAction
