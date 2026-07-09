local t1 = {}

t1.__index = t1

function t1.new(p1) -- line: 9
	-- upvalues: t1 (copy)
	local t2 = {
		_isEnabled = true,
		_reporter = p1
	}

	setmetatable(t2, t1)

	return t2
end
function t1.setEnabled(t3: {[any]: any}, b1: boolean) -- line: 19
	t3._isEnabled = b1
end
function t1.sendTelemetryEvent(t4: {[any]: any}, s1: string, s2: string, t5: {[any]: any}?) -- line: 26
	local v10 = t5 or {}

	assert(type(s1) == "string", "Expected eventContext to be a string")
	assert(type(s2) == "string", "Expected eventName to be a string")
	assert(type(v10) == "table", "Expected additionalArgs to be a table")
	assert(t4._isEnabled, "This reporting service is disabled")
	t4._reporter:logRobloxTelemetryEvent({
		throttlingPercentage = 10000,
		eventName = s2,
		backends = { "EventIngest" }
	}, {
		"addSessionId",
		"addSessionInfo"
	}, v10, s1)
end

return t1
