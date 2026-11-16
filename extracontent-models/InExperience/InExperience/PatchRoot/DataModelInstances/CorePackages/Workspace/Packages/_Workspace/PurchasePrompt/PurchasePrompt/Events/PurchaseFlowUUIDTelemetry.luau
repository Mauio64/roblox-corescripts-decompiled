local parent = script:FindFirstAncestor("PurchasePrompt").Parent
local LoggingProtocol = require(parent.LoggingProtocol)

return {
	ProductPurchaseContainerMigrationCounter = {
		eventName = "ProductPurchaseContainerPurchaseFlowUUID",
		backends = { LoggingProtocol.TelemetryBackends.Counter },
		lastUpdated = { 2025, 1, 21 },
		throttlingPercentage = 100,
		description = "Counter for PurchaseFlowUUID generation in ProductPurchaseContainer init method"
	},
	InitiatePurchaseCounter = {
		eventName = "InitiatePurchasePurchaseFlowUUID",
		backends = { LoggingProtocol.TelemetryBackends.Counter },
		lastUpdated = { 2025, 1, 21 },
		throttlingPercentage = 100,
		description = "Counter for PurchaseFlowUUID generation in initiatePurchase thunk"
	}
}
