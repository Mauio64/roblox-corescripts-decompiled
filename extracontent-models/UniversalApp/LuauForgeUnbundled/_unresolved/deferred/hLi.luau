return {
	eventName = "accountSecurityChallengePrivateAccessTokenEvent",
	backends = { require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsErrorBoundary/LoggingProtocol").TelemetryBackends.EventIngest },
	throttlingPercentage = 10000,
	lastUpdated = { 24, 1, 22 },
	description = "Tracks lifecycle events for the Private Access Token GCS challenge",
	links = "https://roblox.atlassian.net/wiki/spaces/BaS/pages/2871099676/Native+PAT+Tech+Spec#Events-and-Metrics-Tracking%3A"
}
