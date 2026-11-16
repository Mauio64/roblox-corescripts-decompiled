local parent = script:FindFirstAncestor("ServerTriggeredModals").Parent

local LoggingProtocol = require(parent.LoggingProtocol)
local default = LoggingProtocol.default

local v = {
	eventName = "ServerTriggeredModals_HttpStatusCode",
	backends = { LoggingProtocol.TelemetryBackends.Counter },
	lastUpdated = { 25, 8, 29 },
	description = "Response status code from server triggered modals request"
}

return function(endpoint_name: string, value: number?, object)
	if object == nil then
		object = default
	end

	assert(object, "loggingProtocol must exists")

	object:logRobloxTelemetryCounter(v, 1, {
		endpoint_name = endpoint_name,
		status_code = value or "unknown"
	})
end
