local default = require("@game/CorePackages/Workspace/Packages/_Index/SocialStopwatch/LoggingProtocol").default

local defineFastInt = game:DefineFastInt("SocialStopwatchTelementyThrottleHundrethsPercent", 10000)

return {
	eventName = "SocialStopwatchTelementy",
	backends = { default.TelemetryBackends.Points },
	throttlingPercentage = defineFastInt,
	lastUpdated = { 24, 5, 6 },
	description = "Report errors with using the Social Time Stopwatch Library.",
	links = ""
}
