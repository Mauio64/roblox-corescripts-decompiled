return {
	eventName = "PreparePaymentCheckCounter",
	backends = { require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/LoggingProtocol").TelemetryBackends.Counter },
	lastUpdated = { 2024, 9, 27 },
	throttlingPercentage = 100,
	description = "Counter on all preparePayment check",
	links = ""
}
