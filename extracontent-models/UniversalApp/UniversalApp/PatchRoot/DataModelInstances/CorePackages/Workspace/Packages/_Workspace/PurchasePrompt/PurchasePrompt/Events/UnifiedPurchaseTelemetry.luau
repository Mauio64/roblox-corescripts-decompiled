local Parent = script:FindFirstAncestor("PurchasePrompt").Parent
local LoggingProtocol = require(Parent.LoggingProtocol)
local v3 = game:DefineFastInt("UnifiedPurchaseTelemetryEventIngestThrottleHundredthsPercent", 100)

return {
	UnifiedProductPurchaseModalShownCounter = {
		eventName = "UnifiedProductPurchaseModalShownCounter",
		description = "Counter fired when Unified Purchase Modal is shown.",
		backends = { LoggingProtocol.TelemetryBackends.Counter },
		lastUpdated = {
			2025,
			9,
			22
		},
		throttlingPercentage = v3
	},
	UnifiedProductPurchaseModalBuyItemButtonClickedCounter = {
		eventName = "UnifiedProductPurchaseModalBuyItemButtonClickedCounter",
		description = "Counter fired when Unified Purchase Modal buy item button is clicked.",
		backends = { LoggingProtocol.TelemetryBackends.Counter },
		lastUpdated = {
			2025,
			9,
			22
		},
		throttlingPercentage = v3
	},
	UnifiedProductPurchaseModalCancelButtonClickedCounter = {
		eventName = "UnifiedProductPurchaseModalCancelButtonClickedCounter",
		description = "Counter fired when Unified Purchase Modal cancel button is clicked.",
		backends = { LoggingProtocol.TelemetryBackends.Counter },
		lastUpdated = {
			2025,
			9,
			22
		},
		throttlingPercentage = v3
	},
	UnifiedProductPurchaseModalPurchaseAttemptedCounter = {
		eventName = "UnifiedProductPurchaseModalPurchaseAttemptedCounter",
		description = "Counter fired when Unified Purchase Modal purchase attempt is made.",
		backends = { LoggingProtocol.TelemetryBackends.Counter },
		lastUpdated = {
			2025,
			9,
			22
		},
		throttlingPercentage = v3
	},
	UnifiedProductPurchaseModalPurchaseSuccessCounter = {
		eventName = "UnifiedProductPurchaseModalPurchaseSuccessCounter",
		description = "Counter fired when Unified Purchase Modal purchase success occurs.",
		backends = { LoggingProtocol.TelemetryBackends.Counter },
		lastUpdated = {
			2025,
			9,
			22
		},
		throttlingPercentage = v3
	},
	UnifiedProductPurchaseCompletionModalShownCounter = {
		eventName = "UnifiedProductPurchaseCompletionModalShownCounter",
		description = "Counter fired when Unified Purchase Modal purchase success occurs.",
		backends = { LoggingProtocol.TelemetryBackends.Counter },
		lastUpdated = {
			2025,
			9,
			22
		},
		throttlingPercentage = v3
	},
	UnifiedRobuxUpsellModalShownCounter = {
		eventName = "UnifiedRobuxUpsellModalShownCounter",
		description = "Counter fired when Unified Robux Upsell Modal is shown.",
		backends = { LoggingProtocol.TelemetryBackends.Counter },
		lastUpdated = {
			2025,
			10,
			4
		},
		throttlingPercentage = v3
	},
	UnifiedRobuxUpsellModalBuyButtonClickedCounter = {
		eventName = "UnifiedRobuxUpsellModalBuyButtonClickedCounter",
		description = "Counter fired when Unified Robux Upsell Modal buy button is clicked.",
		backends = { LoggingProtocol.TelemetryBackends.Counter },
		lastUpdated = {
			2025,
			10,
			4
		},
		throttlingPercentage = v3
	},
	UnifiedRobuxUpsellRobuxPurchaseCompletedCounter = {
		eventName = "UnifiedRobuxUpsellRobuxPurchaseCompletedCounter",
		description = "Counter fired when Robux was successfully purchased during the Unified Robux Upsell Flow.  Doesn't include successful item purchase after upsell.",
		backends = { LoggingProtocol.TelemetryBackends.Counter },
		lastUpdated = {
			2026,
			2,
			9
		},
		throttlingPercentage = v3
	},
	UnifiedRobuxUpsellRobuxPurchaseFailedCounter = {
		eventName = "UnifiedRobuxUpsellRobuxPurchaseFailedCounter",
		description = "Counter fired when Robux upsell flow failed during balance polling retries in the Unified Robux Upsell Flow.",
		backends = { LoggingProtocol.TelemetryBackends.Counter },
		lastUpdated = {
			2026,
			2,
			9
		},
		throttlingPercentage = v3
	},
	UnifiedCartPricingFetchSucceededCounter = {
		eventName = "UnifiedCartPricingFetchSucceededCounter",
		description = "Counter fired when the cart-pricing fetch resolves.",
		backends = { LoggingProtocol.TelemetryBackends.Counter },
		lastUpdated = {
			2026,
			6,
			2
		},
		throttlingPercentage = v3
	},
	UnifiedCartPricingFetchFailedCounter = {
		eventName = "UnifiedCartPricingFetchFailedCounter",
		description = "Counter fired when the cart-pricing fetch rejects.",
		backends = { LoggingProtocol.TelemetryBackends.Counter },
		lastUpdated = {
			2026,
			6,
			2
		},
		throttlingPercentage = v3
	},
	UnifiedCartPricingHandlerErrorCounter = {
		eventName = "UnifiedCartPricingHandlerErrorCounter",
		description = "Counter fired when the container's cart-pricing success handler throws.",
		backends = { LoggingProtocol.TelemetryBackends.Counter },
		lastUpdated = {
			2026,
			6,
			2
		},
		throttlingPercentage = v3
	},
	UnifiedCartPricingBuyBlockedWhileFetchingCounter = {
		eventName = "UnifiedCartPricingBuyBlockedWhileFetchingCounter",
		description = "Counter fired when a purchase is blocked because a cart-pricing fetch is in flight.",
		backends = { LoggingProtocol.TelemetryBackends.Counter },
		lastUpdated = {
			2026,
			6,
			11
		},
		throttlingPercentage = v3
	},
	UnifiedProductPurchaseFlowEvent = {
		eventName = "UnifiedProductPurchaseFlow",
		description = "Data points on all Unified Product Purchase Flow events.",
		backends = { LoggingProtocol.TelemetryBackends.EventIngest },
		throttlingPercentage = game:DefineFastInt("EnableUnifiedProductPurchaseFlowThrottleHundredthsPercent", 0),
		lastUpdated = {
			2025,
			10,
			4
		}
	}
}
