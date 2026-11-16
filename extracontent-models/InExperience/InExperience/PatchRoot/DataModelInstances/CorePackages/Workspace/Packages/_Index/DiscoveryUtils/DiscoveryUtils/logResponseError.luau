local parent = script:FindFirstAncestor("DiscoveryUtils").Parent
local LoggingProtocol = require(parent.LoggingProtocol)
local default = LoggingProtocol.default

local defineFastInt = game:DefineFastInt("DiscoveryResponseErrorEventHundredthsPercent", 0)

local v = {
	eventName = "DiscoveryResponse_Error",
	backends = { LoggingProtocol.TelemetryBackends.Counter },
	throttlingPercentage = defineFastInt,
	lastUpdated = { 24, 12, 2 },
	description = "Response errors for discovery network requests"
}

local function getStatusCode(p) -- 1 equivalent call inferred from this helper
	local v2

	if typeof(p) == "table" then
		v2 = tostring(p.StatusCode)
	end

	return v2 or "unknown"
end

local function logResponseError(endpoint_name: string, p, object)
	if object == nil then
		object = default
	end

	assert(object, "LoggingProtocol must exist")

	object:logRobloxTelemetryCounter(v, 1, {
		endpoint_name = endpoint_name,
		status_code = getStatusCode(p) -- inferred equivalent call
	})
end

return logResponseError
