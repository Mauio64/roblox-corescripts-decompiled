local RobloxSubscriptionPurchaseApp = script:FindFirstAncestor("RobloxSubscriptionPurchaseApp")
local getFreeTrialOffer = require(RobloxSubscriptionPurchaseApp.Utils.getFreeTrialOffer)

local function isRobloxSubscriptionProductFreeTrial(p): boolean
	return getFreeTrialOffer(p) ~= nil
end

return isRobloxSubscriptionProductFreeTrial
