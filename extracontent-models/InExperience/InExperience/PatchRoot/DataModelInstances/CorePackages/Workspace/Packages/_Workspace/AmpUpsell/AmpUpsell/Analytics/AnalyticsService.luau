local EventIngestService = game:GetService("EventIngestService")

return {
	EventStream = {
		sendEventDeferred = require(script.Parent.sendEventDeferred)(EventIngestService)
	}
}
