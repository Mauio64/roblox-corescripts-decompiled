local Parent = script:FindFirstAncestor("DiscoveryUtils").Parent
local LoggingProtocol = require(Parent.LoggingProtocol)
local default = LoggingProtocol.default
local v4 = game:DefineFastInt("DiscoveryResponseErrorEventHundredthsPercent", 0)
local t1 = {
	eventName = "DiscoveryResponse_Error",
	description = "Response errors for discovery network requests",
	backends = { LoggingProtocol.TelemetryBackends.Counter },
	throttlingPercentage = v4,
	lastUpdated = {
		24,
		12,
		2
	}
}

local function getStatusCode(p1) -- line: 19
	local str = nil

	if typeof(p1) == "table" then
		str = tostring(p1.StatusCode)
	end

	return str or "unknown"
end
local function logResponseError(s1: string, t2: {[any]: any}, p2) -- line: 28
	-- upvalues: default (copy), t1 (copy)
	if p2 == nil then
		p2 = default
	end

	assert(p2, "LoggingProtocol must exist")

	local v13 = t1
	local t3 = {
		endpoint_name = s1
	}
	local str = nil

	if typeof(t2) == "table" then
		str = tostring(t2.StatusCode)
	end

	t3.status_code = str or "unknown"
	p2:logRobloxTelemetryCounter(v13, 1, t3)
end

return logResponseError
