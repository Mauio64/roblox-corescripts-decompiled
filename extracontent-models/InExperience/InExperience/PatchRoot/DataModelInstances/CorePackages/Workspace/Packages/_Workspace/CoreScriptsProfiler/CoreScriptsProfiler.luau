local CoreScriptsProfiler = require(script.CoreScriptsProfiler)
local CoreScriptsProfilerTelemetry = require(script.CoreScriptsProfilerTelemetry)
local ProfilerDataParser = require(script.ProfilerDataParser)

return {
	CoreScriptsProfiler = CoreScriptsProfiler,
	CoreScriptsProfilerTelemetry = CoreScriptsProfilerTelemetry,
	ProfilerDataParser = ProfilerDataParser,
	["jest.config"] = script["jest.config"]
}
