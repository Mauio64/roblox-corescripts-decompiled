local RobloxSubscriptionStore = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Store/RobloxSubscriptionStore")
local cleanupSubscriptionFlow = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Actions/cleanupSubscriptionFlow")

local function handleBackButtonAction()
	RobloxSubscriptionStore.get().triggerOnBackButtonActivated()
	cleanupSubscriptionFlow()
end

return handleBackButtonAction
