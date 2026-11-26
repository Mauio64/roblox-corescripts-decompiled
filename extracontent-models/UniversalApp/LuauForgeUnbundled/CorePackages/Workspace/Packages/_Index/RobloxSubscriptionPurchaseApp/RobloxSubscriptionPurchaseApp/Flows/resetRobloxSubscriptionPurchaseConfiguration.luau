local RobloxSubscriptionStore = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Store/RobloxSubscriptionStore")

local function resetRobloxSubscriptionPurchaseConfiguration()
	local v5 = RobloxSubscriptionStore.get()
	v5.setPurchaseUIOptions({})
	v5.setPurchaseFlowOptions({})
	v5.setOnFlowComplete(nil)
	v5.setOnBackButtonActivated(nil)
	v5.setOnCtaOverride(nil)
end

return resetRobloxSubscriptionPurchaseConfiguration
