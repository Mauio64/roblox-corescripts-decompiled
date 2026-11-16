local EventStreamReporter = {}
EventStreamReporter.__index = EventStreamReporter

function EventStreamReporter.new(reporter)
	local v = { _reporter = reporter, _isEnabled = true }

	setmetatable(v, EventStreamReporter)

	return v
end

function EventStreamReporter:setEnabled(isEnabled: boolean)
	self._isEnabled = isEnabled
end

function EventStreamReporter:sendTelemetryEvent(value: string, value2: string, options)
	local v = options or {}

	assert(type(value) == "string", "Expected eventContext to be a string")
	assert(type(value2) == "string", "Expected eventName to be a string")
	assert(type(v) == "table", "Expected additionalArgs to be a table")
	assert(self._isEnabled, "This reporting service is disabled")

	self._reporter:logRobloxTelemetryEvent({
		eventName = value2,
		backends = { "EventIngest" },
		throttlingPercentage = 10000
	}, { "addSessionId", "addSessionInfo" }, v, value)
end

return EventStreamReporter
