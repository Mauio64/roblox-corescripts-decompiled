return function(value, value2): boolean
	assert(type(value) == "number", "throttle must be a number")
	assert(type(value2) == "number", "userId must be a number")

	return value2 % 100 + 1 <= value
end
