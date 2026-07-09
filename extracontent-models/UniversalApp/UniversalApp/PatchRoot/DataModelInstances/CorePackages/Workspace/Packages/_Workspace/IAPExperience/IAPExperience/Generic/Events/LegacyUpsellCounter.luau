local Parent = script:FindFirstAncestor("IAPExperience").Parent
local LoggingProtocol = require(Parent.LoggingProtocol)

return {
	LegacyUpsellShownCounter = {
		eventName = "LegacyUpsellShownCounter",
		throttlingPercentage = 100,
		description = "Counter on all legacy upsell shown",
		links = "",
		backends = { LoggingProtocol.TelemetryBackends.Counter },
		lastUpdated = {
			2025,
			7,
			15
		}
	}
}
