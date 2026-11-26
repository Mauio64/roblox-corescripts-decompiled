local RobloxSubscriptionStore = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Store/RobloxSubscriptionStore")

local function resetPerFlowState()
	RobloxSubscriptionStore.get().setMembershipConfigSnapshot(nil)
end

return resetPerFlowState
