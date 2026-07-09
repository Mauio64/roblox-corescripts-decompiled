local Parent = script:FindFirstAncestor("IAPExperience").Parent
local LoggingProtocol = require(Parent.LoggingProtocol)

return {
	eventName = "PreparePaymentCheckCounter",
	throttlingPercentage = 100,
	description = "Counter on all preparePayment check",
	links = "",
	backends = { LoggingProtocol.TelemetryBackends.Counter },
	lastUpdated = {
		2024,
		9,
		27
	}
}
