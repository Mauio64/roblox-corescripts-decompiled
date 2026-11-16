local parent = script:FindFirstAncestor("ServerTriggeredModals").Parent

local LoggingProtocol = require(parent.LoggingProtocol)
local default = LoggingProtocol.default

local v = {
	eventName = "ServerTriggeredModals_NetworkLatency",
	backends = { LoggingProtocol.TelemetryBackends.Stats },
	lastUpdated = { 25, 8, 29 },
	description = "Response latency from server triggered modals request"
}

return function(endpoint_name: string, p: number, status_code: number?, object)
	if object == nil then
		object = default
	end

	assert(object, "loggingProtocol must exists")

	object:logRobloxTelemetryStat(v, p, { endpoint_name = endpoint_name, status_code = status_code })
end
