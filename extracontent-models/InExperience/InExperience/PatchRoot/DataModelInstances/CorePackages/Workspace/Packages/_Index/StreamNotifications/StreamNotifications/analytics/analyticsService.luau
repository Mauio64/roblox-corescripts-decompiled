local EventIngestService = game:GetService("EventIngestService")
local StreamNotifications = script:FindFirstAncestor("StreamNotifications")
local sendEventDeferred = require(StreamNotifications.analytics.sendEventDeferred)

return {
	EventStream = {
		sendEventDeferred = sendEventDeferred(EventIngestService)
	}
}
