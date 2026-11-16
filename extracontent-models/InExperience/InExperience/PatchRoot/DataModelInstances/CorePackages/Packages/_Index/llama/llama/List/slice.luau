local function slice(list, value, p)
	local typeName = type(list)
	assert(typeName == "table", "expected a table for first argument, got " .. typeName)

	local count = #list
	value = value or 1
	p = p or count

	assert(value <= p, "start index must be less than or equal to end index")

	local result = {}
	local v = 1

	for i = math.max(1, value), math.min(p, count) do
		result[v] = list[i]
		v += 1
	end

	return result
end

return slice
