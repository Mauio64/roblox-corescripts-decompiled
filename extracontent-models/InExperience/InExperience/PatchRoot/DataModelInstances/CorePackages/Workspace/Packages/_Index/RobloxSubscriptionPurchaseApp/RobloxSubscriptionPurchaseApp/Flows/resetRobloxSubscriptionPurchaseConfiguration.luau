local RobloxSubscriptionPurchaseApp = script:FindFirstAncestor("RobloxSubscriptionPurchaseApp")

local RobloxSubscriptionStore = require(RobloxSubscriptionPurchaseApp.Store.RobloxSubscriptionStore)

local function resetRobloxSubscriptionPurchaseConfiguration()
	local v = RobloxSubscriptionStore.get()
	v.setPurchaseUIOptions({})
	v.setPurchaseFlowOptions({})
	v.setOnFlowComplete(nil)
	v.setOnBackButtonActivated(nil)
	v.setOnCtaOverride(nil)
end

return resetRobloxSubscriptionPurchaseConfiguration
