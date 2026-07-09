local CorePackages = game:GetService("CorePackages")
local LoggingProtocol = require(CorePackages.Workspace.Packages.LoggingProtocol)
local default = LoggingProtocol.default
local t1 = {
	eventName = "CsatSurveyGetLastSurvBloxCallTimestampError",
	description = "\t\tError tracking for SurvBlox call timestamp retrieval.\n\t",
	backends = { LoggingProtocol.TelemetryBackends.Counter },
	lastUpdated = {
		25,
		7,
		21
	}
}

return {
	logGetLastSurvBloxCallTimestampError = function() -- line: 20
		-- upvalues: default (copy), t1 (copy)
		default:logRobloxTelemetryCounter(t1, 1)
	end
}
