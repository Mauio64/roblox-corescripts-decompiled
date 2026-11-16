local RobloxSubscriptionPurchaseApp = script:FindFirstAncestor("RobloxSubscriptionPurchaseApp")

local RobloxSubscriptionStore = require(RobloxSubscriptionPurchaseApp.Store.RobloxSubscriptionStore)

local function cleanupSubscriptionFlow()
	RobloxSubscriptionStore.get().triggerUnmountUI()
	RobloxSubscriptionStore.cleanup()
end

return cleanupSubscriptionFlow
