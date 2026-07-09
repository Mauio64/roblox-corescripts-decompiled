local EventIngestService = game:GetService("EventIngestService")
local StreamNotifications = script:FindFirstAncestor("StreamNotifications")

return {
	EventStream = {
		sendEventDeferred = require(StreamNotifications.analytics.sendEventDeferred)(EventIngestService)
	}
}
