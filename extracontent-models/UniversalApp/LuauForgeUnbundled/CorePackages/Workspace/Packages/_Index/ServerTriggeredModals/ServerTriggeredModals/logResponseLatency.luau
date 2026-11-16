local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/LoggingProtocol")
local default = LoggingProtocol.default

local v5 = {
	eventName = "ServerTriggeredModals_NetworkLatency",
	backends = { LoggingProtocol.TelemetryBackends.Stats },
	lastUpdated = { 25, 8, 29 },
	description = "Response latency from server triggered modals request"
}

return function(p2, p3, p4, object)
	if object == nil then
		object = default
	end

	assert(object, "loggingProtocol must exists")

	object:logRobloxTelemetryStat(v5, p3, { endpoint_name = p2, status_code = p4 })
end
