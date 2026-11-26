local HttpService = game:GetService("HttpService")

local module = require("@luauforge/bundled/hIj")
local module2 = require("@luauforge/bundled/hHP")

local v5 = {
	eventName = "UserPurchaseFlow",
	backends = { "EventIngest" },
	throttlingPercentage = 10000,
	lastUpdated = { 26, 10, 22 },
	description = "SDUI Buy Robux purchase flow mirroring web robuxRedesign"
}

local function sendPurchaseFlowEvent(object, data, p2)
	local v6 = {
		purchase_flow_uuid = data.purchaseFlowUuid,
		view_name = data.viewName,
		purchase_event_type = data.purchaseEventType,
		view_message = data.viewMessage,
		event_metadata = HttpService:JSONEncode(data.eventMetadata or {})
	}

	if module then
		if p2 then
			local sendEventImmediately = p2.sendEventImmediately

			if sendEventImmediately ~= nil then
				sendEventImmediately(p2, data.triggerContext, v5.eventName, v6)
				return
			end
		end

		module2.trackCounter("FlowEventImmediateSendFallback")
	end

	object:LogEvent(v5, {
		eventContext = data.triggerContext,
		standardizedFields = { "addSessionInfo", "addSessionId" },
		customFields = v6
	})
end

return sendPurchaseFlowEvent
