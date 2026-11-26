return {
	eventName = "LuaAppStartupFatalError",
	backends = { require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsErrorBoundary/LoggingProtocol").TelemetryBackends.Counter },
	lastUpdated = { 26, 10, 13 },
	description = "Fatal Lua error before the React root first committed, reported on the next launch"
}
