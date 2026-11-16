local function map(list, callback)
	local typeName = type(list)
	assert(typeName == "table", "expected a table for first argument, got " .. typeName)

	local typeName2 = type(callback)
	assert(typeName2 == "function", "expected a function for second argument, got " .. typeName2)

	local result = {}
	local v = 1

	for i = 1, #list do
		local v2 = callback(list[i], i)

		if v2 == nil then
			continue
		end

		result[v] = v2
		v += 1
	end

	return result
end

return map
