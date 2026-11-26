local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/LoggingProtocol")
local default = LoggingProtocol.default

local v5 = {
	eventName = "ServerTriggeredModals_HttpStatusCode",
	backends = { LoggingProtocol.TelemetryBackends.Counter },
	lastUpdated = { 25, 8, 29 },
	description = "Response status code from server triggered modals request"
}

return function(p2, value, object)
	if object == nil then
		object = default
	end

	assert(object, "loggingProtocol must exists")

	object:logRobloxTelemetryCounter(v5, 1, {
		endpoint_name = p2,
		status_code = value or "unknown"
	})
end
