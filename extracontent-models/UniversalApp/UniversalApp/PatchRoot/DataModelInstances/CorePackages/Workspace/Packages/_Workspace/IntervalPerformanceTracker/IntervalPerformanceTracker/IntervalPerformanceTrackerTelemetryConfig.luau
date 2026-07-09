local Parent = script:FindFirstAncestor("IntervalPerformanceTracker").Parent
local LoggingProtocol = require(Parent.LoggingProtocol)

game:DefineFastInt("IntervalPerformanceTrackerEventThrottleHundrethsPercent", 10000)

return {
	eventName = "luaIntervalPerformanceTrackerTelemetry",
	description = "Report lua performance tracking metrics to Grafana.",
	links = "https://roblox.atlassian.net/wiki/spaces/USER/pages/2379481365/Parallelize+work+through+the+new+multi-threading+API",
	backends = { LoggingProtocol.TelemetryBackends.Points },
	throttlingPercentage = game:GetFastInt("IntervalPerformanceTrackerEventThrottleHundrethsPercent"),
	lastUpdated = {
		24,
		1,
		10
	}
}
