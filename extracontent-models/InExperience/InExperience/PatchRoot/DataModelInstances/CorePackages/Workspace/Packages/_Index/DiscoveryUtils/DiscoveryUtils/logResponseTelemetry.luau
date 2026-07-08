local Parent = script:FindFirstAncestor("DiscoveryUtils").Parent
local default = require(Parent.LoggingProtocol).default
local v3 = game:DefineFastInt("DiscoveryResponseSizeEventHundredthsPercent", 0)
local t1 = {
	eventName = "DiscoveryResponseSize",
	description = "Response body size for discovery network requests",
	links = "",
	backends = { default.TelemetryBackends.Stats },
	throttlingPercentage = v3,
	lastUpdated = {
		24,
		8,
		2
	}
}

local function logResponseTelemetry(s1: string, t2: {[any]: any}, p1) -- line: 23
	-- upvalues: default (copy), t1 (copy)
	if p1 == nil then
		p1 = default
	end

	assert(p1, "LoggingProtocol must exist")
	p1:logRobloxTelemetryStat(t1, t2.responseSize, {
		endpoint_name = s1
	})
end

return logResponseTelemetry
