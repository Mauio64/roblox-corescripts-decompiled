local CorePackages = game:GetService("CorePackages")
local LoggingProtocol = require(CorePackages.Workspace.Packages.LoggingProtocol)

return {
	description = "Report Lua errors to Points with document name \"luashellerrors\"",
	links = "https://grafana.simulprod.com/d/grdIrDiVz/lua-apps-error-metrics?orgId=1",
	eventName = settings():GetFVariable("LuaErrorsInfluxSeries"),
	backends = { LoggingProtocol.TelemetryBackends.Points },
	throttlingPercentage = tonumber(settings():GetFVariable("LuaErrorsInfluxThrottling")),
	lastUpdated = {
		22,
		7,
		29
	}
}
