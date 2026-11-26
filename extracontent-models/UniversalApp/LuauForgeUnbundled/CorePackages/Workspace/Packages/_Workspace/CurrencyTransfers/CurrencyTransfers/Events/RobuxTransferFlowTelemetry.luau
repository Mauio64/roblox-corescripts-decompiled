return {
	RobuxTransferFlowEvent = {
		eventName = "RobuxTransferFlow",
		backends = { require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/LoggingProtocol").TelemetryBackends.EventIngest },
		throttlingPercentage = game:DefineFastInt(
			"RobuxTransferFlowEventIngestThrottleHundredthsPercent",
			0
		),
		lastUpdated = { 2026, 4, 2 },
		description = "Robux transfer funnel; correlate via transfer_request_id and transfer_client_session_id."
	}
}
