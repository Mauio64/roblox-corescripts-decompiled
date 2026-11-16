local AvatarExperienceAnalytics = script:FindFirstAncestor("AvatarExperienceAnalytics")
local parent = AvatarExperienceAnalytics.Parent

local LoggingProtocol = require(parent.LoggingProtocol)

local FIntBulkPurchaseMissingPurchaseOptionsCounterThrottleHundredthsPercent = require(AvatarExperienceAnalytics.Flags.FIntBulkPurchaseMissingPurchaseOptionsCounterThrottleHundredthsPercent)

return {
	eventName = "BulkPurchaseMissingPurchaseOptionsCounter",
	backends = { LoggingProtocol.TelemetryBackends.Counter },
	lastUpdated = { 2026, 5, 7 },
	throttlingPercentage = FIntBulkPurchaseMissingPurchaseOptionsCounterThrottleHundredthsPercent(),
	description = "Counter fired when bulk purchase server response contains at least one item missing purchaseOptions while FFlagBulkPurchaseUsesPurchaseOptionDiscount is on.",
	links = ""
}
