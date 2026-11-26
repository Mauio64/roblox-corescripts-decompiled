local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/LoggingProtocol")

return {
	PurchaseModalV1ShownCounter = {
		eventName = "PurchaseModalV1ShownCounter",
		backends = { LoggingProtocol.TelemetryBackends.Counter },
		lastUpdated = { 2025, 8, 4 },
		throttlingPercentage = 100,
		description = "Counter fired when In Experience Purchase Modal v1 is shown",
		links = ""
	},
	PurchaseModalV2ShownCounter = {
		eventName = "PurchaseModalV2ShownCounter",
		backends = { LoggingProtocol.TelemetryBackends.Counter },
		lastUpdated = { 2025, 8, 4 },
		throttlingPercentage = 100,
		description = "Counter fired when In Experience Purchase Modal v2 is shown",
		links = ""
	}
}
