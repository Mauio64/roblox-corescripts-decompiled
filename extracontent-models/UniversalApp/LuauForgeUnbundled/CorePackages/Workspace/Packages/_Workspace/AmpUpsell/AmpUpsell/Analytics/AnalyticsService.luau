local EventIngestService = game:GetService("EventIngestService")
return {
	EventStream = {
		sendEventDeferred = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Analytics/sendEventDeferred")(EventIngestService)
	}
}
