local CorePackages = game:GetService("CorePackages")
local LoggingProtocol = require(CorePackages.Workspace.Packages.LoggingProtocol)

game:DefineFastInt("ToCPopupOccuranceThrottleHundrethsPercent", 0)

return {
	eventName = "ToCPopupOccurance",
	description = "Report ocurrance of ToC popup",
	backends = { LoggingProtocol.TelemetryBackends.Points },
	throttlingPercentage = game:GetFastInt("ToCPopupOccuranceThrottleHundrethsPercent"),
	lastUpdated = {
		23,
		3,
		8
	}
}
