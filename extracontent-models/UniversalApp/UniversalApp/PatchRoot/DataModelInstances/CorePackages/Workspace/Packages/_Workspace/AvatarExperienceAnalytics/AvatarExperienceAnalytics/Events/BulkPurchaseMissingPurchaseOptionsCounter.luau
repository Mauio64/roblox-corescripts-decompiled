local AvatarExperienceAnalytics = script:FindFirstAncestor("AvatarExperienceAnalytics")
local AvatarExperienceAnalyticsParent = AvatarExperienceAnalytics.Parent
local LoggingProtocol = require(AvatarExperienceAnalyticsParent.LoggingProtocol)
local FIntBulkPurchaseMissingPurchaseOptionsCounterThrottleHundredthsPercent = require(AvatarExperienceAnalytics.Flags.FIntBulkPurchaseMissingPurchaseOptionsCounterThrottleHundredthsPercent)

return {
	eventName = "BulkPurchaseMissingPurchaseOptionsCounter",
	description = "Counter fired when bulk purchase server response contains at least one item missing purchaseOptions while FFlagBulkPurchaseUsesPurchaseOptionDiscount is on.",
	links = "",
	backends = { LoggingProtocol.TelemetryBackends.Counter },
	lastUpdated = {
		2026,
		5,
		7
	},
	throttlingPercentage = FIntBulkPurchaseMissingPurchaseOptionsCounterThrottleHundredthsPercent()
}
