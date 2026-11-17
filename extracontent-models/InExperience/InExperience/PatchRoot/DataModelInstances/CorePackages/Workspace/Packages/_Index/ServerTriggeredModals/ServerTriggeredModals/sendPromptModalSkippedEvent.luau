local TelemetryService = game:GetService("TelemetryService")

local parent = script:FindFirstAncestor("ServerTriggeredModals").Parent

local LoggingProtocol = require(parent.LoggingProtocol)

local v = {
	eventName = "PromptModalSkipped",
	backends = { LoggingProtocol.TelemetryBackends.EventIngest },
	throttlingPercentage = game:DefineFastInt("PromptModalSkippedThrottleHundredthsPercent", 10000),
	lastUpdated = { 26, 11, 11 },
	description = "Sent when a served prompt modal is not shown",
	links = ""
}

return function(customFields)
	TelemetryService:LogEvent(v, {
		standardizedFields = { "addSessionInfo" },
		customFields = customFields
	})
end
