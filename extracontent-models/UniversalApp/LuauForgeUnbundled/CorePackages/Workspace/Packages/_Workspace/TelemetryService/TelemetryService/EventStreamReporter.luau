local class = {}
class.__index = class

function class.new(p2)
	local v5 = { _reporter = p2, _isEnabled = true }

	setmetatable(v5, class)

	return v5
end

function class:setEnabled(isEnabled)
	self._isEnabled = isEnabled
end

function class:sendTelemetryEvent(value, value2, options)
	local v5 = options or {}

	assert(type(value) == "string", "Expected eventContext to be a string")
	assert(type(value2) == "string", "Expected eventName to be a string")
	assert(type(v5) == "table", "Expected additionalArgs to be a table")
	assert(self._isEnabled, "This reporting service is disabled")

	self._reporter:logRobloxTelemetryEvent({
		eventName = value2,
		backends = { "EventIngest" },
		throttlingPercentage = 10000
	}, { "addSessionId", "addSessionInfo" }, v5, value)
end

return class
