local UserInputService = game:GetService("UserInputService")

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

function class:reportCounter(value, value2)
	assert(type(value) == "string", "Expected counterName to be a string")
	assert(type(value2) == "number", "Expected amount to be a number")
	assert(self._isEnabled, "This reporting service is disabled")

	local v5 = Enum.Platform.None
	pcall(function()
		v5 = UserInputService:GetPlatform()
	end)

	if v5 == Enum.Platform.XBoxOne then
		value = "Xbox-" .. tostring(value)
	end

	self._reporter:ReportCounter(value, value2)
end

function class:reportCounterSimple(p3, p4)
	if self._isEnabled then
		self._reporter:ReportCounter(p3, p4)
	end
end

function class:reportStats(value, value2)
	assert(type(value) == "string", "Expected category to be a string")
	assert(type(value2) == "number", "Expected value to be a number")
	assert(self._isEnabled, "This reporting service is disabled")

	self._reporter:ReportStats(value, value2)
end

return class
