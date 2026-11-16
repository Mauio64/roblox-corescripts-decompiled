local EventIngestService = game:GetService("EventIngestService")
local sendEventDeferred = require(script.Parent.sendEventDeferred)

return {
	EventStream = {
		sendEventDeferred = sendEventDeferred(EventIngestService)
	}
}
