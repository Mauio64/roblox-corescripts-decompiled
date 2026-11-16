local parent = script:FindFirstAncestor("IAPExperience").Parent
local LoggingProtocol = require(parent.LoggingProtocol)

return {
	eventName = "PreparePaymentCheckCounter",
	backends = { LoggingProtocol.TelemetryBackends.Counter },
	lastUpdated = { 2024, 9, 27 },
	throttlingPercentage = 100,
	description = "Counter on all preparePayment check",
	links = ""
}
