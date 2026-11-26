return {
	eventName = "luaAppRootUnmountQuitTiming",
	backends = { require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsErrorBoundary/LoggingProtocol").TelemetryBackends.EventIngest },
	throttlingPercentage = 10000,
	lastUpdated = { 26, 10, 28 },
	description = "Reported on the launch after a UniversalApp root unmount or a crash caught by the root error boundary: how long the process stayed alive, when it was first hidden, and whether an auto-restart was scheduled"
}
