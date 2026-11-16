local parent = script:FindFirstAncestor("IAPExperience").Parent
local LoggingProtocol = require(parent.LoggingProtocol)

return {
	ProductPurchasePromptCounter = {
		eventName = "ProductPurchaseErrorPromptShownCounter",
		backends = { LoggingProtocol.TelemetryBackends.Counter },
		lastUpdated = { 2025, 8, 26 },
		throttlingPercentage = 100,
		description = "Counter on all product purchase error prompt shown",
		links = ""
	}
}
