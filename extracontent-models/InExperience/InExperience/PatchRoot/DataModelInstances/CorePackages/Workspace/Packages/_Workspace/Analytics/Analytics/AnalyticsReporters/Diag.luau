local UserInputService = game:GetService("UserInputService")
local t1 = {}

t1.__index = t1

function t1.new(p1) -- line: 27
	-- upvalues: t1 (copy)
	local v4 = type(p1)

	assert(v4 == "table" or v4 == "userdata", "Unexpected value for reportingService")

	local t2 = {
		_isEnabled = true,
		_reporter = p1
	}

	setmetatable(t2, t1)

	return t2
end
function t1.setEnabled(t3: {[any]: any}, b1: boolean) -- line: 40
	assert(type(b1) == "boolean", "Expected isEnabled to be a boolean")
	t3._isEnabled = b1
end
function t1.reportCounter(t4: {[any]: any}, s1: string, n1: number) -- line: 47
	-- upvalues: UserInputService (copy)
	assert(type(s1) == "string", "Expected counterName to be a string")
	assert(type(n1) == "number", "Expected amount to be a number")
	assert(t4._isEnabled, "This reporting service is disabled")

	local None = Enum.Platform.None

	pcall(function() -- line: 56
		-- upvalues: None (ref), UserInputService (copy)
		None = UserInputService:GetPlatform()
	end)

	if None == Enum.Platform.XBoxOne then
		s1 = "Xbox-" .. tostring(s1)
	end

	t4._reporter:ReportCounter(s1, n1)
end
function t1.reportCounterSimple(t5: {[any]: any}, s2: string, n2: number) -- line: 69
	if t5._isEnabled then
		t5._reporter:ReportCounter(s2, n2)
	end
end
function t1.reportStats(t6: {[any]: any}, s3: string, n3: number) -- line: 77
	assert(type(s3) == "string", "Expected category to be a string")
	assert(type(n3) == "number", "Expected value to be a number")
	assert(t6._isEnabled, "This reporting service is disabled")
	t6._reporter:ReportStats(s3, n3)
end

return t1
