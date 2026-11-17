local RobloxSubscriptionPurchaseApp = script:FindFirstAncestor("RobloxSubscriptionPurchaseApp")

local RobloxSubscriptionStore = require(RobloxSubscriptionPurchaseApp.Store.RobloxSubscriptionStore)

local function resetPerFlowState()
	RobloxSubscriptionStore.get().setMembershipConfigSnapshot(nil)
end

return resetPerFlowState
