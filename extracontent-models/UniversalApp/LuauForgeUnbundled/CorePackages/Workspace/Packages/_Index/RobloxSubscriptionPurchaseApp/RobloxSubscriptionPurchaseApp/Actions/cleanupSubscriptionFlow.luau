local RobloxSubscriptionStore = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Store/RobloxSubscriptionStore")

local function cleanupSubscriptionFlow()
	RobloxSubscriptionStore.get().triggerUnmountUI()
	RobloxSubscriptionStore.cleanup()
end

return cleanupSubscriptionFlow
