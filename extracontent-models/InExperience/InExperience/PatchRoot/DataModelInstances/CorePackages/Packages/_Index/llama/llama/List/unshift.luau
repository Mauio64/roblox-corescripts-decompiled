local function unshift(list, ...)
	local typeName = type(list)
	assert(typeName == "table", "expected a table for first argument, got " .. typeName)

	local v = select("#", ...)

	local result = {}

	for i = 1, v do
		result[i] = select(i, ...)
	end

	for i = 1, #list do
		result[v + i] = list[i]
	end

	return result
end

return unshift
