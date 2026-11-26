local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Index/DiscoveryUtils/LoggingProtocol")
local default = LoggingProtocol.default

local defineFastInt = game:DefineFastInt("DiscoveryResponseErrorEventHundredthsPercent", 0)

local v5 = {
	eventName = "DiscoveryResponse_Error",
	backends = { LoggingProtocol.TelemetryBackends.Counter },
	throttlingPercentage = defineFastInt,
	lastUpdated = { 24, 12, 2 },
	description = "Response errors for discovery network requests"
}

local function getStatusCode(p2)
	return (if typeof(p2) == "table" then tostring(p2.StatusCode) else nil) or "unknown"
end

local function logResponseError(p2, p3, object)
	if object == nil then
		object = default
	end

	assert(object, "LoggingProtocol must exist")
	local v9 = if typeof(p3) == "table" then tostring(p3.StatusCode) else nil

	object:logRobloxTelemetryCounter(v5, 1, {
		endpoint_name = p2,
		status_code = v9 or "unknown"
	})
end

return logResponseError
