local parent = script:FindFirstAncestor("DiscoveryUtils").Parent
local LoggingProtocol = require(parent.LoggingProtocol)
local default = LoggingProtocol.default

local defineFastInt = game:DefineFastInt("DiscoveryResponseSizeEventHundredthsPercent", 0)

local v = {
	eventName = "DiscoveryResponseSize",
	backends = { default.TelemetryBackends.Stats },
	throttlingPercentage = defineFastInt,
	lastUpdated = { 24, 8, 2 },
	description = "Response body size for discovery network requests",
	links = ""
}

local function logResponseTelemetry(endpoint_name: string, p, object)
	if object == nil then
		object = default
	end

	assert(object, "LoggingProtocol must exist")

	object:logRobloxTelemetryStat(v, p.responseSize, { endpoint_name = endpoint_name })
end

return logResponseTelemetry
