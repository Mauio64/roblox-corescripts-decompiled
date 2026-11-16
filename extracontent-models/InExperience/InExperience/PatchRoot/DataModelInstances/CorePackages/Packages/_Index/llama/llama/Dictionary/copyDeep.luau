local function copyDeep(item)
	local typeName = type(item)
	assert(typeName == "table", "expected a table for first argument, got " .. typeName)

	local result = {}

	for k, item2 in pairs(item) do
		if type(item2) == "table" then
			result[k] = copyDeep(item2)
		else
			result[k] = item2
		end
	end

	return result
end

return copyDeep
