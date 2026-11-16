local function copyDeep(list)
	local typeName = type(list)
	assert(typeName == "table", "expected a table for first argument, got " .. typeName)

	local result = {}

	for i = 1, #list do
		if type(list[i]) == "table" then
			result[i] = copyDeep(list[i])
		else
			result[i] = list[i]
		end
	end

	return result
end

return copyDeep
