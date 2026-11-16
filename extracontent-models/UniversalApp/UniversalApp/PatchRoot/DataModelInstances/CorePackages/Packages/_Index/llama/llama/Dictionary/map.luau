local function map(items, callback)
	local typeName = type(items)
	assert(typeName == "table", "expected a table for first argument, got " .. typeName)

	local typeName2 = type(callback)
	assert(typeName2 == "function", "expected a function for second argument, got " .. typeName2)

	local result = {}

	for k, item in pairs(items) do
		local v, v2 = callback(item, k)
		result[v2 or k] = v
	end

	return result
end

return map
