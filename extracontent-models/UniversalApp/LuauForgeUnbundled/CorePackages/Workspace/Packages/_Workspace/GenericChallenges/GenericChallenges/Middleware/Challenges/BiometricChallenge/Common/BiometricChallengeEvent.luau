return {
	eventName = "accountSecurityChallengeBiometricEvent",
	backends = { require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/LoggingProtocol").TelemetryBackends.EventIngest },
	throttlingPercentage = 10000,
	lastUpdated = { 25, 9, 11 },
	description = "Tracks lifecycle events for the Biometric GCS challenge",
	links = "https://roblox.atlassian.net/wiki/x/rQR02"
}
