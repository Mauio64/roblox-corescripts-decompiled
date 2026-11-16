local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/LoggingProtocol")

return {
	PurchaseErrorPromptShownCounter = {
		eventName = "PurchaseErrorPromptShownCounter",
		backends = { LoggingProtocol.TelemetryBackends.Counter },
		lastUpdated = { 2025, 5, 20 },
		throttlingPercentage = 100,
		description = "Counter on all purchase error prompt shown",
		links = ""
	},
	EconomicRestrictionsPromptShownCounter = {
		eventName = "EconomicRestrictionsPromptShownCounter",
		backends = { LoggingProtocol.TelemetryBackends.Counter },
		lastUpdated = { 2025, 5, 20 },
		throttlingPercentage = 100,
		description = "Counter on all economic restrictions prompt shown",
		links = ""
	}
}
