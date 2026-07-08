local Parent = script:FindFirstAncestor("PurchasePrompt").Parent
local LoggingProtocol = require(Parent.LoggingProtocol)

return {
	ProductPurchaseContainerMigrationCounter = {
		eventName = "ProductPurchaseContainerPurchaseFlowUUID",
		throttlingPercentage = 100,
		description = "Counter for PurchaseFlowUUID generation in ProductPurchaseContainer init method",
		backends = { LoggingProtocol.TelemetryBackends.Counter },
		lastUpdated = {
			2025,
			1,
			21
		}
	},
	InitiatePurchaseCounter = {
		eventName = "InitiatePurchasePurchaseFlowUUID",
		throttlingPercentage = 100,
		description = "Counter for PurchaseFlowUUID generation in initiatePurchase thunk",
		backends = { LoggingProtocol.TelemetryBackends.Counter },
		lastUpdated = {
			2025,
			1,
			21
		}
	}
}
