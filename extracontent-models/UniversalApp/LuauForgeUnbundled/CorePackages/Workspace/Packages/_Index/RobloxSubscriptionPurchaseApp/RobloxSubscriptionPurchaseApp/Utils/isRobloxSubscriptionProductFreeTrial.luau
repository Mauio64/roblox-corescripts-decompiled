local getFreeTrialOffer = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Utils/getFreeTrialOffer")

local function isRobloxSubscriptionProductFreeTrial(p2): boolean
	return getFreeTrialOffer(p2) ~= nil
end

return isRobloxSubscriptionProductFreeTrial
