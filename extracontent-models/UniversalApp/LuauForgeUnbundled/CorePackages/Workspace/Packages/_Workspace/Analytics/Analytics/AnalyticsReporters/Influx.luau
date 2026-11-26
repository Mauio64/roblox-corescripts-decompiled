local class = {}
class.__index = class

function class.new(p2)
	local typeName = type(p2)
	assert(typeName == "table" or typeName == "userdata", "Unexpected value for reportingService")

	local v5 = { _reporter = p2, _isEnabled = true }

	setmetatable(v5, class)

	return v5
end

function class:setEnabled(isEnabled)
	assert(type(isEnabled) == "boolean", "Expected isEnabled to be a boolean")
	self._isEnabled = isEnabled
end

function class:reportSeries(value, options, value2)
	local v5 = options or {}

	assert(type(value) == "string", "Expected seriesName to be a string")
	assert(type(v5) == "table", "Expected additionalArgs to be a table")
	assert(type(value2) == "number", "Expected throttlingPercent to be a number")
	local v6 = value2 >= 0 and value2 <= 10000
	assert(v6, "throttlingPercent must be between 0 - 10,000")
	assert(self._isEnabled, "This reporting service is disabled")

	self._reporter:ReportInfluxSeries(value, v5, value2)
end

return class
