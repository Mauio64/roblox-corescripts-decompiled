local RobloxSubscriptionPurchaseApp = script:FindFirstAncestor("RobloxSubscriptionPurchaseApp")
local RobloxSubscriptionStore = require(RobloxSubscriptionPurchaseApp.Store.RobloxSubscriptionStore)
local cleanupSubscriptionFlow = require(RobloxSubscriptionPurchaseApp.Actions.cleanupSubscriptionFlow)

local function handleBackButtonAction() -- line: 6
	-- upvalues: RobloxSubscriptionStore (copy), cleanupSubscriptionFlow (copy)
	RobloxSubscriptionStore.get().triggerOnBackButtonActivated()
	cleanupSubscriptionFlow()
end

return handleBackButtonAction
