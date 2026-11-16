local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/LoggingProtocol")

return {
	TooExpensiveUpsellShownCounter = {
		eventName = "TooExpensiveUpsellShownCounter",
		backends = { LoggingProtocol.TelemetryBackends.Counter },
		lastUpdated = { 2025, 7, 29 },
		throttlingPercentage = 100,
		description = "Counter fired when Robux too expensive upsell modal shown",
		links = ""
	},
	TooExpensiveUpsellFallbackShownCounter = {
		eventName = "TooExpensiveUpsellFallbackShownCounter",
		backends = { LoggingProtocol.TelemetryBackends.Counter },
		lastUpdated = { 2025, 7, 29 },
		throttlingPercentage = 100,
		description = "Counter fired when Robux too expensive fallback modal shown",
		links = ""
	},
	TooExpensiveUnifiedUpsellShownCounter = {
		eventName = "TooExpensiveUnifiedUpsellShownCounter",
		backends = { LoggingProtocol.TelemetryBackends.Counter },
		lastUpdated = { 2025, 9, 29 },
		throttlingPercentage = 100,
		description = "Counter fired when Robux too expensive unified upsell modal shown",
		links = ""
	}
}
