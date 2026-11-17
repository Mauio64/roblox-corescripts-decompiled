local parent = script:FindFirstAncestor("GenericChallenges").Parent
local LoggingProtocol = require(parent.LoggingProtocol)

return {
	eventName = "accountSecurityChallengeDeniedEvent",
	backends = { LoggingProtocol.TelemetryBackends.EventIngest },
	throttlingPercentage = 10000,
	lastUpdated = { 26, 11, 4 },
	description = "Tracks lifecycle events for the native Denied GCS challenge"
}
