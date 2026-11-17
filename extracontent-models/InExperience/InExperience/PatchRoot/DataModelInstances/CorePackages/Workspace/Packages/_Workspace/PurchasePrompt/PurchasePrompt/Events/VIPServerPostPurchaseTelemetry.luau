local parent = script:FindFirstAncestor("PurchasePrompt").Parent
local LoggingProtocol = require(parent.LoggingProtocol)

local defineFastInt = game:DefineFastInt("VIPServerPostPurchaseTelemetryThrottleHundredthsPercent", 10000)

return {
	PrivateServerConfigEvent = {
		eventName = "privateServerConfig",
		backends = { LoggingProtocol.TelemetryBackends.EventIngest },
		lastUpdated = { 2026, 11, 6 },
		throttlingPercentage = defineFastInt,
		description = "Impressions and clicks on the in-experience private server setup and join screens."
	},
	VIPServerTeleportFailedCounter = {
		eventName = "VIPServerPostPurchaseTeleportFailedCounter",
		backends = { LoggingProtocol.TelemetryBackends.Counter },
		lastUpdated = { 2026, 11, 6 },
		throttlingPercentage = defineFastInt,
		description = "Counter fired when teleporting the buyer into their new private server fails."
	}
}
