return {
	eventName = "CrossAppLoginSuccess",
	backends = { require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsErrorBoundary/LoggingProtocol").TelemetryBackends.EphemeralCounter },
	throttlingPercentage = 10000,
	lastUpdated = { 26, 10, 22 },
	description = "Count a successful cross-app login from the approver dialog.",
	links = "https://roblox.atlassian.net/wiki/spaces/Client/pages/2496467637/Engine+Telemetry+V2+API+Migration+Guide"
}
