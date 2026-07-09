local Parent = script:FindFirstAncestor("RobloxSubscriptionPurchaseApp").Parent
local LoggingProtocol = require(Parent.LoggingProtocol)
local v3 = game:DefineFastInt("RobloxSubscriptionUpsellTelemetryEventIngestThrottleHundredthsPercent", 0)

return {
	RobloxSubscriptionUpsellModalInitiatedCounter = {
		eventName = "RobloxSubscriptionUpsellModalInitiatedCounter",
		description = "Counter fired when Roblox Subscription Upsell Modal is initiated.",
		backends = { LoggingProtocol.TelemetryBackends.Counter },
		lastUpdated = {
			2026,
			3,
			3
		},
		throttlingPercentage = v3
	},
	RobloxSubscriptionUpsellModalShownCounter = {
		eventName = "RobloxSubscriptionUpsellModalShownCounter",
		description = "Counter fired when Roblox Subscription Upsell Modal is shown.",
		backends = { LoggingProtocol.TelemetryBackends.Counter },
		lastUpdated = {
			2026,
			3,
			3
		},
		throttlingPercentage = v3
	},
	RobloxSubscriptionUpsellModalBuyButtonClickedCounter = {
		eventName = "RobloxSubscriptionUpsellModalBuyButtonClickedCounter",
		description = "Counter fired when Roblox Subscription Upsell Modal buy button is clicked.",
		backends = { LoggingProtocol.TelemetryBackends.Counter },
		lastUpdated = {
			2026,
			3,
			3
		},
		throttlingPercentage = v3
	},
	RobloxSubscriptionUpsellFlowCompletedCounter = {
		eventName = "RobloxSubscriptionUpsellFlowCompletedCounter",
		description = "Counter fired when purchase was succesful.",
		backends = { LoggingProtocol.TelemetryBackends.Counter },
		lastUpdated = {
			2026,
			3,
			3
		},
		throttlingPercentage = v3
	},
	RobloxSubscriptionUpsellNativePurchaseCompletedCounter = {
		eventName = "RobloxSubscriptionUpsellNativePurchaseCompletedCounter",
		description = "Counter fired when purchase was succesful.",
		backends = { LoggingProtocol.TelemetryBackends.Counter },
		lastUpdated = {
			2026,
			3,
			3
		},
		throttlingPercentage = v3
	},
	RobloxSubscriptionUpsellDismissedCounter = {
		eventName = "RobloxSubscriptionUpsellDismissedCounter",
		description = "Counter fired when modal is dismissed.",
		backends = { LoggingProtocol.TelemetryBackends.Counter },
		lastUpdated = {
			2026,
			3,
			3
		},
		throttlingPercentage = v3
	},
	RobloxSubscriptionUpsellPurchaseFailedCounter = {
		eventName = "RobloxSubscriptionUpsellPurchaseFailedCounter",
		description = "Counter fired when purchase failed.",
		backends = { LoggingProtocol.TelemetryBackends.Counter },
		lastUpdated = {
			2026,
			3,
			3
		},
		throttlingPercentage = v3
	},
	RobloxSubscriptionUpsellPurchaseSucceededCounter = {
		eventName = "RobloxSubscriptionUpsellPurchaseSucceededCounter",
		description = "Counter fired when purchase succeeded.",
		backends = { LoggingProtocol.TelemetryBackends.Counter },
		lastUpdated = {
			2026,
			3,
			9
		},
		throttlingPercentage = v3
	},
	RobloxSubscriptionUpsellNativePurchasePollingTimeoutCounter = {
		eventName = "RobloxSubscriptionUpsellNativePurchasePollingTimeoutCounter",
		description = "Counter fired when native purchase polling timeout occurs after native purchase attempt.",
		backends = { LoggingProtocol.TelemetryBackends.Counter },
		lastUpdated = {
			2026,
			3,
			9
		},
		throttlingPercentage = v3
	},
	RobloxSubscriptionPurchaseAttemptedCounter = {
		eventName = "RobloxSubscriptionPurchaseAttemptedCounter",
		description = "Counter fired when purchase attempt is made.",
		backends = { LoggingProtocol.TelemetryBackends.Counter },
		lastUpdated = {
			2026,
			3,
			9
		},
		throttlingPercentage = v3
	},
	RobloxSubscriptionPurchaseErrorShownCounter = {
		eventName = "RobloxSubscriptionPurchaseErrorShownCounter",
		description = "Counter fired when purchase error is shown.",
		backends = { LoggingProtocol.TelemetryBackends.Counter },
		lastUpdated = {
			2026,
			3,
			24
		},
		throttlingPercentage = v3
	},
	RobloxSubscriptionCreatePaymentSessionFailedCounter = {
		eventName = "RobloxSubscriptionCreatePaymentSessionFailedCounter",
		description = "Counter fired when create payment session fails.",
		backends = { LoggingProtocol.TelemetryBackends.Counter },
		lastUpdated = {
			2026,
			3,
			25
		},
		throttlingPercentage = v3
	},
	RobloxSubscriptionCreatePaymentSessionFailedEvent = {
		eventName = "RobloxSubscriptionCreatePaymentSessionFailed",
		description = "Point event logged when create payment session fails, includes error details for Kibana.",
		backends = { LoggingProtocol.TelemetryBackends.Points },
		lastUpdated = {
			2026,
			5,
			1
		},
		throttlingPercentage = v3
	}
}
