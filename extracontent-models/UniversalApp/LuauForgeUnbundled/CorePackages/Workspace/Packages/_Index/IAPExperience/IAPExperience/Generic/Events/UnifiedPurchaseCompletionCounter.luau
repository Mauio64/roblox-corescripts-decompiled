return {
	UnifiedProductPurchaseCompletionModalShownCounter = {
		eventName = "UnifiedProductPurchaseCompletionModalShownCounter",
		backends = { require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/LoggingProtocol").TelemetryBackends.Counter },
		lastUpdated = { 2025, 10, 8 },
		throttlingPercentage = 100,
		description = "Counter fired when Unified Purchase Completion Modal is shown."
	}
}
