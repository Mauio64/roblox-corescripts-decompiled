local EventIngestService = game:GetService("EventIngestService")

return {
	EventStream = {
		sendEventDeferred = require("@game/CorePackages/Workspace/Packages/_Index/StreamNotifications/StreamNotifications/analytics/sendEventDeferred")(EventIngestService)
	}
}
