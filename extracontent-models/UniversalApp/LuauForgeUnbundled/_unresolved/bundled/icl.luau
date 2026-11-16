local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsErrorBoundary/LoggingProtocol")

local default = LoggingProtocol.default

local v5 = {
	eventName = "CsatSurveyGetLastSurvBloxCallTimestampError",
	backends = { LoggingProtocol.TelemetryBackends.Counter },
	lastUpdated = { 25, 7, 21 },
	description = "\t\t\tError tracking for SurvBlox call timestamp retrieval.\n\t\t"
}

return {
	logGetLastSurvBloxCallTimestampError = function()
		default:logRobloxTelemetryCounter(v5, 1)
	end
}
