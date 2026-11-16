require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Network/getRobloxSubscriptionProducts")
local isRobloxSubscriptionProductFreeTrial = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Utils/isRobloxSubscriptionProductFreeTrial")

local function isRobloxPlusFreeTrialEligible(list)
	if type(list) == "table" and list[1] ~= nil then
		return isRobloxSubscriptionProductFreeTrial(list[1])
	end

	return false
end

return isRobloxPlusFreeTrialEligible
