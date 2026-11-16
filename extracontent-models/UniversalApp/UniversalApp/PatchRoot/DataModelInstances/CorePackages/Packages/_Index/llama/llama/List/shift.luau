local function shift(list, value)
	local typeName = type(list)
	assert(typeName == "table", "expected a table for first argument, got " .. typeName)

	value = value or 1
	local typeName2 = type(value)
	local v = typeName2 == "number" and value % 1 == 0
	assert(v, "expected an integer for second argument, got " .. typeName2)

	local result = {}

	for i = 1 + value, #list do
		result[i - value] = list[i]
	end

	return result
end

return shift
