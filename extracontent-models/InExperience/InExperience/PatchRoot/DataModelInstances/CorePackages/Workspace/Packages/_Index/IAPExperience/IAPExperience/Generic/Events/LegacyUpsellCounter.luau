local parent = script:FindFirstAncestor("IAPExperience").Parent
local LoggingProtocol = require(parent.LoggingProtocol)

return {
	LegacyUpsellShownCounter = {
		eventName = "LegacyUpsellShownCounter",
		backends = { LoggingProtocol.TelemetryBackends.Counter },
		lastUpdated = { 2025, 7, 15 },
		throttlingPercentage = 100,
		description = "Counter on all legacy upsell shown",
		links = ""
	}
}
