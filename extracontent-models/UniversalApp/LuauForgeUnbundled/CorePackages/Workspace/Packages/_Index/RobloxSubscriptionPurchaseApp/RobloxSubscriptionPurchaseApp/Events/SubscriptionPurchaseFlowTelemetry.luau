return {
	SubscriptionPurchaseFlowEvent = {
		eventName = "SubscriptionPurchaseFlow",
		backends = { require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/LoggingProtocol").TelemetryBackends.EventIngest },
		throttlingPercentage = game:DefineFastInt(
			"SubscriptionPurchaseFlowEventIngestThrottleHundredthsPercent",
			0
		),
		lastUpdated = { 2026, 4, 2 },
		description = "Subscription purchase funnel (upsell, modal, purchase outcomes); correlates via client_session_id_type + client_session_id."
	}
}
