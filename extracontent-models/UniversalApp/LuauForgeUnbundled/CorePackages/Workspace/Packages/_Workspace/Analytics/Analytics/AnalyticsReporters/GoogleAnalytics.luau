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

function class:trackEvent(value, value2, value3, value4)
	assert(type(value) == "string", "Expected category to be a string")
	assert(type(value2) == "string", "Expected action to be a string")

	if value3 then
		assert(type(value3) == "string", "Expected label to be a string")
	end

	if value4 then
		assert(type(value4) == "number", "Expected value to be a number")
		assert(value4 >= 0, "Expected value must not be a negative value")
	end

	assert(self._isEnabled, "This reporting service is disabled")

	self._reporter:TrackEvent(value, value2, value3, value4)
end

return class
