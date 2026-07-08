require(script.Analytics.Types)
require(script.Analytics.Enums.Contexts)
require(script.Analytics.Enums.PlatformSpecificity)

local telemetryNewConfig = require(script.Telemetry.telemetryNewConfig)
local Performance = require(script.Performance)

return {
	["jest.config"] = script["jest.config"],
	Analytics = require(script.Analytics),
	TestingAnalytics = require(script.TestingAnalytics),
	Performance = Performance,
	Telemetry = {
		new = telemetryNewConfig,
		createEmitter = require(script.Telemetry.telemetryCreateEmitter)
	}
}
