local function values(items)
	local typeName = type(items)
	assert(typeName == "table", "expected a table for first argument, got " .. typeName)

	local result = {}
	local v = 1

	for _, item in pairs(items) do
		result[v] = item
		v += 1
	end

	return result
end

return values
