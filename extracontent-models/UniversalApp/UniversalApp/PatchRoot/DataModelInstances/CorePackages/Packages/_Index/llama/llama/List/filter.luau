local function filter(list, callback)
	local typeName = type(list)
	assert(typeName == "table", "expected a table for first argument, got " .. typeName)

	local typeName2 = type(callback)
	assert(typeName2 == "function", "expected a function for second argument, got " .. typeName2)

	local result = {}
	local v = 1

	for i = 1, #list do
		if not callback(list[i], i) then
			continue
		end

		result[v] = list[i]
		v += 1
	end

	return result
end

return filter
