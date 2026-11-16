return {
	eventName = "LuaAppRootErrorBoundaryCaught",
	backends = { require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsErrorBoundary/LoggingProtocol").TelemetryBackends.Counter },
	lastUpdated = { 26, 10, 27 },
	description = "Report the app root error boundary catching a render error, tagged with whether an auto-restart was scheduled"
}
