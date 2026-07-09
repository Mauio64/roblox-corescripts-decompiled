local Parent = script:FindFirstAncestor("GenericChallenges").Parent
local LoggingProtocol = require(Parent.LoggingProtocol)

return {
	eventName = "accountSecurityChallengeBiometricEvent",
	throttlingPercentage = 10000,
	description = "Tracks lifecycle events for the Biometric GCS challenge",
	links = "https://roblox.atlassian.net/wiki/x/rQR02",
	backends = { LoggingProtocol.TelemetryBackends.EventIngest },
	lastUpdated = {
		25,
		9,
		11
	}
}
