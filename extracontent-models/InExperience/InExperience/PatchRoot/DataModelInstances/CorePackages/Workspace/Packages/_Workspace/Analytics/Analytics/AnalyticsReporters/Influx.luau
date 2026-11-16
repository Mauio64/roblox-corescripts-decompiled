local Influx = {}
Influx.__index = Influx

function Influx.new(reporter)
	local typeName = type(reporter)
	assert(typeName == "table" or typeName == "userdata", "Unexpected value for reportingService")

	local v = { _reporter = reporter, _isEnabled = true }

	setmetatable(v, Influx)

	return v
end

function Influx:setEnabled(isEnabled: boolean)
	assert(type(isEnabled) == "boolean", "Expected isEnabled to be a boolean")
	self._isEnabled = isEnabled
end

function Influx:reportSeries(value: string, options, value2: number)
	local v = options or {}

	assert(type(value) == "string", "Expected seriesName to be a string")
	assert(type(v) == "table", "Expected additionalArgs to be a table")
	assert(type(value2) == "number", "Expected throttlingPercent to be a number")
	local v2 = value2 >= 0 and value2 <= 10000
	assert(v2, "throttlingPercent must be between 0 - 10,000")
	assert(self._isEnabled, "This reporting service is disabled")

	self._reporter:ReportInfluxSeries(value, v, value2)
end

return Influx
