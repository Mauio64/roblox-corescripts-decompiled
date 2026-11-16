local function copy(list)
	local typeName = type(list)
	assert(typeName == "table", "expected a table for first argument, got " .. typeName)

	local result = {}

	for i = 1, #list do
		result[i] = list[i]
	end

	return result
end

return copy
