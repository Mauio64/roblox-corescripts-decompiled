return {
	LegacyUpsellShownCounter = {
		eventName = "LegacyUpsellShownCounter",
		backends = { require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/LoggingProtocol").TelemetryBackends.Counter },
		lastUpdated = { 2025, 7, 15 },
		throttlingPercentage = 100,
		description = "Counter on all legacy upsell shown",
		links = ""
	}
}
