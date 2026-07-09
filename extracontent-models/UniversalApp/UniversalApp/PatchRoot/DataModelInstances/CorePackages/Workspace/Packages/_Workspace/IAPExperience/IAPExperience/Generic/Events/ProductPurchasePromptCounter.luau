local Parent = script:FindFirstAncestor("IAPExperience").Parent
local LoggingProtocol = require(Parent.LoggingProtocol)

return {
	ProductPurchasePromptCounter = {
		eventName = "ProductPurchaseErrorPromptShownCounter",
		throttlingPercentage = 100,
		description = "Counter on all product purchase error prompt shown",
		links = "",
		backends = { LoggingProtocol.TelemetryBackends.Counter },
		lastUpdated = {
			2025,
			8,
			26
		}
	}
}
