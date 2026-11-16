local HttpService = game:GetService("HttpService")

local v5 = {
	eventName = "UserPurchaseFlow",
	backends = { "EventIngest" },
	throttlingPercentage = 10000,
	lastUpdated = { 26, 10, 22 },
	description = "SDUI Buy Robux purchase flow mirroring web robuxRedesign"
}

local function sendPurchaseFlowEvent(object, data)
	object:LogEvent(v5, {
		eventContext = data.triggerContext,
		standardizedFields = { "addSessionInfo", "addSessionId" },
		customFields = {
			purchase_flow_uuid = data.purchaseFlowUuid,
			view_name = data.viewName,
			purchase_event_type = data.purchaseEventType,
			view_message = data.viewMessage,
			event_metadata = HttpService:JSONEncode(data.eventMetadata or {})
		}
	})
end

return sendPurchaseFlowEvent
