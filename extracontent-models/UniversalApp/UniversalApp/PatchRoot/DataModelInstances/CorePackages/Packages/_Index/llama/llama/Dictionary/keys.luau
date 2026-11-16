local function keys(items)
	local typeName = type(items)
	assert(typeName == "table", "expected a table for first argument, got " .. typeName)

	local result = {}
	local v = 1

	for k, _ in pairs(items) do
		result[v] = k
		v += 1
	end

	return result
end

return keys
