local Parent = script:FindFirstAncestor("IAPExperience").Parent
local LoggingProtocol = require(Parent.LoggingProtocol)

return {
	PurchaseModalV1ShownCounter = {
		eventName = "PurchaseModalV1ShownCounter",
		throttlingPercentage = 100,
		description = "Counter fired when In Experience Purchase Modal v1 is shown",
		links = "",
		backends = { LoggingProtocol.TelemetryBackends.Counter },
		lastUpdated = {
			2025,
			8,
			4
		}
	},
	PurchaseModalV2ShownCounter = {
		eventName = "PurchaseModalV2ShownCounter",
		throttlingPercentage = 100,
		description = "Counter fired when In Experience Purchase Modal v2 is shown",
		links = "",
		backends = { LoggingProtocol.TelemetryBackends.Counter },
		lastUpdated = {
			2025,
			8,
			4
		}
	}
}
