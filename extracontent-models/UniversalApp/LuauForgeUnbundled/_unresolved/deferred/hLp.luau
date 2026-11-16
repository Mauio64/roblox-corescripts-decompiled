local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsErrorBoundary/LoggingProtocol")

game:DefineFastInt("ToCPopupOccuranceThrottleHundrethsPercent", 0)

return {
	eventName = "ToCPopupOccurance",
	backends = { LoggingProtocol.TelemetryBackends.Points },
	throttlingPercentage = game:GetFastInt("ToCPopupOccuranceThrottleHundrethsPercent"),
	lastUpdated = { 23, 3, 8 },
	description = "Report ocurrance of ToC popup"
}
