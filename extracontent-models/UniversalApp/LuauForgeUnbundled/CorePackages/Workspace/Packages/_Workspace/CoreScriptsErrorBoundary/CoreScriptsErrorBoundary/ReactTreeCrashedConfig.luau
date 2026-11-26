return {
	eventName = "LuaAppReactTreeUnmounted",
	backends = { require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsErrorBoundary/LoggingProtocol").TelemetryBackends.Counter },
	lastUpdated = { 26, 8, 28 },
	description = "Report the app React tree being torn down"
}
