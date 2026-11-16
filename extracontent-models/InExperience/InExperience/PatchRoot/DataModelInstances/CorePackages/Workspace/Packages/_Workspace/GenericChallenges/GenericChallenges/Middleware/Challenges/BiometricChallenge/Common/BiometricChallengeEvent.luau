local parent = script:FindFirstAncestor("GenericChallenges").Parent
local LoggingProtocol = require(parent.LoggingProtocol)

return {
	eventName = "accountSecurityChallengeBiometricEvent",
	backends = { LoggingProtocol.TelemetryBackends.EventIngest },
	throttlingPercentage = 10000,
	lastUpdated = { 25, 9, 11 },
	description = "Tracks lifecycle events for the Biometric GCS challenge",
	links = "https://roblox.atlassian.net/wiki/x/rQR02"
}
