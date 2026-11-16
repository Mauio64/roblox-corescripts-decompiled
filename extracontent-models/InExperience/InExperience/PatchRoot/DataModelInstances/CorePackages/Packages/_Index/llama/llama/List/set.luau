local function set(list, p, p2)
	local typeName = type(list)
	assert(typeName == "table", "expected a table for first argument, got " .. typeName)

	local count = #list

	assert(p <= count, "index must be less than or equal to the list length")
	assert(p >= 1, "index must be greater than or equal to 1")

	local result = {}
	local v = 1

	for i = 1, count do
		if i == p then
			result[v] = p2
		else
			result[v] = list[i]
		end

		v += 1
	end

	return result
end

return set
