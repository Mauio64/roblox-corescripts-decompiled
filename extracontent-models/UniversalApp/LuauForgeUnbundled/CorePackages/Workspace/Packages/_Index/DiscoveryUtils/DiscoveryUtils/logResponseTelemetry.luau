local default = require("@game/CorePackages/Workspace/Packages/_Index/DiscoveryUtils/LoggingProtocol").default

local defineFastInt = game:DefineFastInt("DiscoveryResponseSizeEventHundredthsPercent", 0)

local v5 = {
	eventName = "DiscoveryResponseSize",
	backends = { default.TelemetryBackends.Stats },
	throttlingPercentage = defineFastInt,
	lastUpdated = { 24, 8, 2 },
	description = "Response body size for discovery network requests",
	links = ""
}

local function logResponseTelemetry(p2, p3, object)
	if object == nil then
		object = default
	end

	assert(object, "LoggingProtocol must exist")

	object:logRobloxTelemetryStat(v5, p3.responseSize, { endpoint_name = p2 })
end

return logResponseTelemetry
