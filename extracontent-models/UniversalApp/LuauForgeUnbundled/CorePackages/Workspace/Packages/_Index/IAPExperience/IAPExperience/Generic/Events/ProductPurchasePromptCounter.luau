return {
	ProductPurchasePromptCounter = {
		eventName = "ProductPurchaseErrorPromptShownCounter",
		backends = { require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/LoggingProtocol").TelemetryBackends.Counter },
		lastUpdated = { 2025, 8, 26 },
		throttlingPercentage = 100,
		description = "Counter on all product purchase error prompt shown",
		links = ""
	}
}
