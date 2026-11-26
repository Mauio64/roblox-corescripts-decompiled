local buildSubscriptionPurchaseFlowPayload = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Utils/buildSubscriptionPurchaseFlowPayload")
local sendSubscriptionPurchaseFlowEvent = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Utils/sendSubscriptionPurchaseFlowEvent")

local function logSubscriptionPurchaseFlowEvent(p2, items)
	local v5 = buildSubscriptionPurchaseFlowPayload(p2)

	if items then
		for k, item in pairs(items) do
			v5[k] = item
		end
	end

	sendSubscriptionPurchaseFlowEvent(v5)
end

return logSubscriptionPurchaseFlowEvent
