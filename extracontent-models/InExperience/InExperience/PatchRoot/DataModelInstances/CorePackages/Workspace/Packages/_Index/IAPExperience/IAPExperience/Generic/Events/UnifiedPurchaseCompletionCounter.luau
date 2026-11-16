local parent = script:FindFirstAncestor("IAPExperience").Parent
local LoggingProtocol = require(parent.LoggingProtocol)

return {
	UnifiedProductPurchaseCompletionModalShownCounter = {
		eventName = "UnifiedProductPurchaseCompletionModalShownCounter",
		backends = { LoggingProtocol.TelemetryBackends.Counter },
		lastUpdated = { 2025, 10, 8 },
		throttlingPercentage = 100,
		description = "Counter fired when Unified Purchase Completion Modal is shown."
	}
}
