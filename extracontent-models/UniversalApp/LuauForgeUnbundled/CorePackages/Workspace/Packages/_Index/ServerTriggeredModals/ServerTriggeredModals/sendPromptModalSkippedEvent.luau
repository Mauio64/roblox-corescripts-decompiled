local TelemetryService = game:GetService("TelemetryService")

local v5 = {
	eventName = "PromptModalSkipped",
	backends = { require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/LoggingProtocol").TelemetryBackends.EventIngest },
	throttlingPercentage = game:DefineFastInt("PromptModalSkippedThrottleHundredthsPercent", 10000),
	lastUpdated = { 26, 11, 11 },
	description = "Sent when a served prompt modal is not shown",
	links = ""
}

return function(p2)
	TelemetryService:LogEvent(v5, {
		standardizedFields = { "addSessionInfo" },
		customFields = p2
	})
end
