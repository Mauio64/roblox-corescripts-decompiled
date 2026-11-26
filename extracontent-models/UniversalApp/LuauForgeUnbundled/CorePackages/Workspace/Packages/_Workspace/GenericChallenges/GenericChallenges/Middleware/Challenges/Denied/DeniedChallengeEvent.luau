return {
	eventName = "accountSecurityChallengeDeniedEvent",
	backends = { require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/LoggingProtocol").TelemetryBackends.EventIngest },
	throttlingPercentage = 10000,
	lastUpdated = { 26, 11, 4 },
	description = "Tracks lifecycle events for the native Denied GCS challenge"
}
