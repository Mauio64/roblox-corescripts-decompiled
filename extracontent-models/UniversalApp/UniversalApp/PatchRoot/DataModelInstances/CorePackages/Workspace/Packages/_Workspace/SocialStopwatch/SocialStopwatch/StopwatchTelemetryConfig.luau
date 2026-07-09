local Parent = script:FindFirstAncestor("SocialStopwatch").Parent
local default = require(Parent.LoggingProtocol).default
local v3 = game:DefineFastInt("SocialStopwatchTelementyThrottleHundrethsPercent", 10000)

return {
	eventName = "SocialStopwatchTelementy",
	description = "Report errors with using the Social Time Stopwatch Library.",
	links = "",
	backends = { default.TelemetryBackends.Points },
	throttlingPercentage = v3,
	lastUpdated = {
		24,
		5,
		6
	}
}
