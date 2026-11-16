local parent = script.Parent.Parent

local LoggingProtocol = require(parent.LoggingProtocol)

return {
	eventName = "LuaCoreScriptsReactTreeCrashed",
	backends = { LoggingProtocol.TelemetryBackends.Counter },
	lastUpdated = { 26, 10, 8 },
	description = "Report a CoreScripts React tree being torn down by an uncaught error, tagged by surface"
}
