local EventIngestService = game:GetService("EventIngestService")
return {
	EventStream = {
		sendEventDeferred = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/ToastNotification/analytics/sendEventDeferred")(EventIngestService)
	}
}
