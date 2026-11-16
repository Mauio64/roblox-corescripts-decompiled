local RobloxSubscriptionPurchaseApp = script:FindFirstAncestor("RobloxSubscriptionPurchaseApp")

local buildSubscriptionPurchaseFlowPayload = require(RobloxSubscriptionPurchaseApp.Utils.buildSubscriptionPurchaseFlowPayload)
local sendSubscriptionPurchaseFlowEvent = require(RobloxSubscriptionPurchaseApp.Utils.sendSubscriptionPurchaseFlowEvent)

local function logSubscriptionPurchaseFlowEvent(p: string, items)
	local subscriptionPurchaseFlowPayload = buildSubscriptionPurchaseFlowPayload(p)

	if items then
		for k, item in pairs(items) do
			subscriptionPurchaseFlowPayload[k] = item
		end
	end

	sendSubscriptionPurchaseFlowEvent(subscriptionPurchaseFlowPayload)
end

return logSubscriptionPurchaseFlowEvent
