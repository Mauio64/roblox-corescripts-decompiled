local Parent = script:FindFirstAncestor("ServerTriggeredModals").Parent
local LoggingProtocol = require(Parent.LoggingProtocol)
local default = LoggingProtocol.default
local t1 = {
	eventName = "ServerTriggeredModals_HttpStatusCode",
	description = "Response status code from server triggered modals request",
	backends = { LoggingProtocol.TelemetryBackends.Counter },
	lastUpdated = {
		25,
		8,
		29
	}
}

return function(s1: string, n1: number?, p1) -- line: 18
	-- upvalues: default (copy), t1 (copy)
	if p1 == nil then
		p1 = default
	end

	assert(p1, "loggingProtocol must exists")
	p1:logRobloxTelemetryCounter(t1, 1, {
		endpoint_name = s1,
		status_code = n1 or "unknown"
	})
end
