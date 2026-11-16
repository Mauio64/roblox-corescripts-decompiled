local function push(list, ...)
	local typeName = type(list)
	assert(typeName == "table", "expected a table for first argument, got " .. typeName)

	local count = #list
	local result = {}

	for i = 1, count do
		result[i] = list[i]
	end

	for i = 1, select("#", ...) do
		result[count + i] = select(i, ...)
	end

	return result
end

return push
