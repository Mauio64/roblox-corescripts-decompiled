local RobloxSubscriptionPurchaseApp = script:FindFirstAncestor("RobloxSubscriptionPurchaseApp")
local RobloxSubscriptionStore = require(RobloxSubscriptionPurchaseApp.Store.RobloxSubscriptionStore)

local function cleanupSubscriptionFlow() -- line: 5
	-- upvalues: RobloxSubscriptionStore (copy)
	RobloxSubscriptionStore.get().triggerUnmountUI()
	RobloxSubscriptionStore.cleanup()
end

return cleanupSubscriptionFlow
