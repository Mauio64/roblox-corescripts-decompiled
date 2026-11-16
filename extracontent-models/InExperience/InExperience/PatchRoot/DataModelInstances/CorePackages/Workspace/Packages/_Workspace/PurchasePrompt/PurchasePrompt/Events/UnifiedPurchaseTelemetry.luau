local parent = script:FindFirstAncestor("PurchasePrompt").Parent
local LoggingProtocol = require(parent.LoggingProtocol)

local defineFastInt = game:DefineFastInt("UnifiedPurchaseTelemetryEventIngestThrottleHundredthsPercent", 100)

return {
	UnifiedProductPurchaseModalShownCounter = {
		eventName = "UnifiedProductPurchaseModalShownCounter",
		backends = { LoggingProtocol.TelemetryBackends.Counter },
		lastUpdated = { 2025, 9, 22 },
		throttlingPercentage = defineFastInt,
		description = "Counter fired when Unified Purchase Modal is shown."
	},
	UnifiedProductPurchaseModalBuyItemButtonClickedCounter = {
		eventName = "UnifiedProductPurchaseModalBuyItemButtonClickedCounter",
		backends = { LoggingProtocol.TelemetryBackends.Counter },
		lastUpdated = { 2025, 9, 22 },
		throttlingPercentage = defineFastInt,
		description = "Counter fired when Unified Purchase Modal buy item button is clicked."
	},
	UnifiedProductPurchaseModalCancelButtonClickedCounter = {
		eventName = "UnifiedProductPurchaseModalCancelButtonClickedCounter",
		backends = { LoggingProtocol.TelemetryBackends.Counter },
		lastUpdated = { 2025, 9, 22 },
		throttlingPercentage = defineFastInt,
		description = "Counter fired when Unified Purchase Modal cancel button is clicked."
	},
	UnifiedProductPurchaseModalPurchaseAttemptedCounter = {
		eventName = "UnifiedProductPurchaseModalPurchaseAttemptedCounter",
		backends = { LoggingProtocol.TelemetryBackends.Counter },
		lastUpdated = { 2025, 9, 22 },
		throttlingPercentage = defineFastInt,
		description = "Counter fired when Unified Purchase Modal purchase attempt is made."
	},
	UnifiedProductPurchaseModalPurchaseSuccessCounter = {
		eventName = "UnifiedProductPurchaseModalPurchaseSuccessCounter",
		backends = { LoggingProtocol.TelemetryBackends.Counter },
		lastUpdated = { 2025, 9, 22 },
		throttlingPercentage = defineFastInt,
		description = "Counter fired when Unified Purchase Modal purchase success occurs."
	},
	UnifiedProductPurchaseCompletionModalShownCounter = {
		eventName = "UnifiedProductPurchaseCompletionModalShownCounter",
		backends = { LoggingProtocol.TelemetryBackends.Counter },
		lastUpdated = { 2025, 9, 22 },
		throttlingPercentage = defineFastInt,
		description = "Counter fired when Unified Purchase Modal purchase success occurs."
	},
	UnifiedRobuxUpsellModalShownCounter = {
		eventName = "UnifiedRobuxUpsellModalShownCounter",
		backends = { LoggingProtocol.TelemetryBackends.Counter },
		lastUpdated = { 2025, 10, 4 },
		throttlingPercentage = defineFastInt,
		description = "Counter fired when Unified Robux Upsell Modal is shown."
	},
	UnifiedRobuxUpsellModalBuyButtonClickedCounter = {
		eventName = "UnifiedRobuxUpsellModalBuyButtonClickedCounter",
		backends = { LoggingProtocol.TelemetryBackends.Counter },
		lastUpdated = { 2025, 10, 4 },
		throttlingPercentage = defineFastInt,
		description = "Counter fired when Unified Robux Upsell Modal buy button is clicked."
	},
	UnifiedRobuxUpsellRobuxPurchaseCompletedCounter = {
		eventName = "UnifiedRobuxUpsellRobuxPurchaseCompletedCounter",
		backends = { LoggingProtocol.TelemetryBackends.Counter },
		lastUpdated = { 2026, 2, 9 },
		throttlingPercentage = defineFastInt,
		description = "Counter fired when Robux was successfully purchased during the Unified Robux Upsell Flow.  Doesn't include successful item purchase after upsell."
	},
	UnifiedRobuxUpsellRobuxPurchaseFailedCounter = {
		eventName = "UnifiedRobuxUpsellRobuxPurchaseFailedCounter",
		backends = { LoggingProtocol.TelemetryBackends.Counter },
		lastUpdated = { 2026, 2, 9 },
		throttlingPercentage = defineFastInt,
		description = "Counter fired when Robux upsell flow failed during balance polling retries in the Unified Robux Upsell Flow."
	},
	UnifiedCartPricingFetchSucceededCounter = {
		eventName = "UnifiedCartPricingFetchSucceededCounter",
		backends = { LoggingProtocol.TelemetryBackends.Counter },
		lastUpdated = { 2026, 6, 2 },
		throttlingPercentage = defineFastInt,
		description = "Counter fired when the cart-pricing fetch resolves."
	},
	UnifiedCartPricingFetchFailedCounter = {
		eventName = "UnifiedCartPricingFetchFailedCounter",
		backends = { LoggingProtocol.TelemetryBackends.Counter },
		lastUpdated = { 2026, 6, 2 },
		throttlingPercentage = defineFastInt,
		description = "Counter fired when the cart-pricing fetch rejects."
	},
	UnifiedCartPricingHandlerErrorCounter = {
		eventName = "UnifiedCartPricingHandlerErrorCounter",
		backends = { LoggingProtocol.TelemetryBackends.Counter },
		lastUpdated = { 2026, 6, 2 },
		throttlingPercentage = defineFastInt,
		description = "Counter fired when the container's cart-pricing success handler throws."
	},
	UnifiedCartPricingBuyBlockedWhileFetchingCounter = {
		eventName = "UnifiedCartPricingBuyBlockedWhileFetchingCounter",
		backends = { LoggingProtocol.TelemetryBackends.Counter },
		lastUpdated = { 2026, 6, 11 },
		throttlingPercentage = defineFastInt,
		description = "Counter fired when a purchase is blocked because a cart-pricing fetch is in flight."
	},
	UnifiedProductPurchaseFlowEvent = {
		eventName = "UnifiedProductPurchaseFlow",
		backends = { LoggingProtocol.TelemetryBackends.EventIngest },
		throttlingPercentage = game:DefineFastInt("EnableUnifiedProductPurchaseFlowThrottleHundredthsPercent", 0),
		lastUpdated = { 2025, 10, 4 },
		description = "Data points on all Unified Product Purchase Flow events."
	}
}
