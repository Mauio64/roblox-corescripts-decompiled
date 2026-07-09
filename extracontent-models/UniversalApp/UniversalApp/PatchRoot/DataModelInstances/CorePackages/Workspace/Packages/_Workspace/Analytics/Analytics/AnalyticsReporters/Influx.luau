local t1 = {}

t1.__index = t1

function t1.new(p1) -- line: 27
	-- upvalues: t1 (copy)
	local v3 = type(p1)

	assert(v3 == "table" or v3 == "userdata", "Unexpected value for reportingService")

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
function t1.reportSeries(t4: {[any]: any}, s1: string, t5: {[any]: any}?, n1: number) -- line: 48
	local v11 = t5 or {}

	assert(type(s1) == "string", "Expected seriesName to be a string")
	assert(type(v11) == "table", "Expected additionalArgs to be a table")
	assert(type(n1) == "number", "Expected throttlingPercent to be a number")
	assert(n1 >= 0 and n1 <= 10000, "throttlingPercent must be between 0 - 10,000")
	assert(t4._isEnabled, "This reporting service is disabled")
	t4._reporter:ReportInfluxSeries(s1, v11, n1)
end

return t1
