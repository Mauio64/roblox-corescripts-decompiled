local EventIngestService = game:GetService("EventIngestService")
local TelemetryService = game:GetService("TelemetryService")

local eventIngest = require("@luauforge/bundled/bZt").AnalyticsReporters.EventIngest

local v5 = {
	eventName = "lockScreenWidgetClickedCounter",
	backends = { "RobloxTelemetryCounter" },
	lastUpdated = { 26, 9, 2 },
	description = "Counter for lock screen widget clicks.",
	links = ""
}

local function logLockScreenWidgetClicked(p2)
	eventIngest.new(EventIngestService):sendEventDeferred(
		"lockScreenWidgetClicked",
		"lockScreenWidgetClicked",
		{ page = p2 }
	)

	TelemetryService:LogCounter(v5, {
		customFields = { page = p2 }
	}, 1)
end

return logLockScreenWidgetClicked
