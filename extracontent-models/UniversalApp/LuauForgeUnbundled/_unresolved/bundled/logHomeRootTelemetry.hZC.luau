local TelemetryService = game:GetService("TelemetryService")

local v5 = {
	eventName = "homeRootTelemetryCounter",
	backends = { "RobloxTelemetryCounter" },
	lastUpdated = { 2026, 9, 21 },
	description = "Counts game_details homeroot deep links.",
	links = ""
}

local function logHomeRootTelemetry(p2)
	TelemetryService:LogCounter(v5, {
		customFields = { context = p2 }
	}, 1)
end

return logHomeRootTelemetry
