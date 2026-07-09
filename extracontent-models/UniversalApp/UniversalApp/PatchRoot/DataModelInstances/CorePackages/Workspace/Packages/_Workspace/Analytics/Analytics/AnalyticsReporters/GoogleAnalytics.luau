local t1 = {}

t1.__index = t1

function t1.new(p1) -- line: 24
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
function t1.setEnabled(t3: {[any]: any}, b1: boolean) -- line: 37
	assert(type(b1) == "boolean", "Expected isEnabled to be a boolean")
	t3._isEnabled = b1
end
function t1.trackEvent(t4: {[any]: any}, s1: string, s2: string, s3: string?, n1: number?) -- line: 46
	assert(type(s1) == "string", "Expected category to be a string")
	assert(type(s2) == "string", "Expected action to be a string")

	if s3 then
		assert(type(s3) == "string", "Expected label to be a string")
	end

	if n1 then
		assert(type(n1) == "number", "Expected value to be a number")
		assert(n1 >= 0, "Expected value must not be a negative value")
	end

	assert(t4._isEnabled, "This reporting service is disabled")
	t4._reporter:TrackEvent(s1, s2, s3, n1)
end

return t1
