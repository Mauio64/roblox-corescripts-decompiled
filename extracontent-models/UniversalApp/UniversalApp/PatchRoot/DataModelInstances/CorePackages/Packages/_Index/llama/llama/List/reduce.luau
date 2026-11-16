local function reduce(list, callback, p)
	local typeName = type(list)
	assert(typeName == "table", "expected a table for first argument, got " .. typeName)

	local typeName2 = type(callback)
	assert(typeName2 == "function", "expected a function for second argument, got " .. typeName2)

	local v = if p == nil then list[1] else p

	for i = p == nil and 2 or 1, #list do
		v = callback(v, list[i], i)
	end

	return v
end

return reduce
