local RobloxSubscriptionPurchaseApp = script:FindFirstAncestor("RobloxSubscriptionPurchaseApp")
local buildSubscriptionPurchaseFlowPayload = require(RobloxSubscriptionPurchaseApp.Utils.buildSubscriptionPurchaseFlowPayload)
local sendSubscriptionPurchaseFlowEvent = require(RobloxSubscriptionPurchaseApp.Utils.sendSubscriptionPurchaseFlowEvent)

local function logSubscriptionPurchaseFlowEvent(s1: string, t1: {[any]: any}?) -- line: 11
	-- upvalues: buildSubscriptionPurchaseFlowPayload (copy), sendSubscriptionPurchaseFlowEvent (copy)
	local v7 = buildSubscriptionPurchaseFlowPayload(s1)

	if t1 then
		for k, v in pairs(t1) do
			v7[k] = v
		end
	end

	sendSubscriptionPurchaseFlowEvent(v7)
end

return logSubscriptionPurchaseFlowEvent
