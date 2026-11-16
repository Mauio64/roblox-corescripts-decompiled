local function get(p, p2)
	local typeName = type(p)
	assert(typeName == "table", "expected a table for first argument, got " .. typeName)

	local typeName2 = type(p2)
	local v = typeName2 == "number" and p2 % 1 == 0
	assert(v, "expected second argument to be an integer, got " .. typeName2)

	return p[p2]
end

return get
