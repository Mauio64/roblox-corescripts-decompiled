local UserInputService = game:GetService("UserInputService")

local Diag = {}
Diag.__index = Diag

function Diag.new(reporter)
	local typeName = type(reporter)
	assert(typeName == "table" or typeName == "userdata", "Unexpected value for reportingService")

	local v = { _reporter = reporter, _isEnabled = true }

	setmetatable(v, Diag)

	return v
end

function Diag:setEnabled(isEnabled: boolean)
	assert(type(isEnabled) == "boolean", "Expected isEnabled to be a boolean")
	self._isEnabled = isEnabled
end

function Diag:reportCounter(value: string, value2: number)
	assert(type(value) == "string", "Expected counterName to be a string")
	assert(type(value2) == "number", "Expected amount to be a number")
	assert(self._isEnabled, "This reporting service is disabled")

	local v = Enum.Platform.None
	pcall(function()
		v = UserInputService:GetPlatform()
	end)

	if v == Enum.Platform.XBoxOne then
		value = "Xbox-" .. tostring(value)
	end

	self._reporter:ReportCounter(value, value2)
end

function Diag:reportCounterSimple(p: string, p2: number)
	if self._isEnabled then
		self._reporter:ReportCounter(p, p2)
	end
end

function Diag:reportStats(value: string, value2: number)
	assert(type(value) == "string", "Expected category to be a string")
	assert(type(value2) == "number", "Expected value to be a number")
	assert(self._isEnabled, "This reporting service is disabled")

	self._reporter:ReportStats(value, value2)
end

return Diag
