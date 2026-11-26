local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/LoggingProtocol")

local FIntBulkPurchaseMissingPurchaseOptionsCounterThrottleHundredthsPercent = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/Flags/FIntBulkPurchaseMissingPurchaseOptionsCounterThrottleHundredthsPercent")

return {
	eventName = "BulkPurchaseMissingPurchaseOptionsCounter",
	backends = { LoggingProtocol.TelemetryBackends.Counter },
	lastUpdated = { 2026, 5, 7 },
	throttlingPercentage = FIntBulkPurchaseMissingPurchaseOptionsCounterThrottleHundredthsPercent(),
	description = "Counter fired when bulk purchase server response contains at least one item missing purchaseOptions while FFlagBulkPurchaseUsesPurchaseOptionDiscount is on.",
	links = ""
}
