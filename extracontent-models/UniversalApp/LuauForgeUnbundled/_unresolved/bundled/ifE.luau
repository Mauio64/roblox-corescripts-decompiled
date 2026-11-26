local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsErrorBoundary/LoggingProtocol")

return {
	eventName = settings():GetFVariable("LuaErrorsInfluxSeries"),
	backends = { LoggingProtocol.TelemetryBackends.Points },
	throttlingPercentage = tonumber(settings():GetFVariable("LuaErrorsInfluxThrottling")),
	lastUpdated = { 22, 7, 29 },
	description = "Report Lua errors to Points with document name \"luashellerrors\"",
	links = "https://grafana.simulprod.com/d/grdIrDiVz/lua-apps-error-metrics?orgId=1"
}
