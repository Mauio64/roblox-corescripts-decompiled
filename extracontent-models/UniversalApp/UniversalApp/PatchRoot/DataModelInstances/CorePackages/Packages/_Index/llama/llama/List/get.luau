local function get(p1, p2) -- line: 2
	local v4 = type(p1)

	assert(v4 == "table", "expected a table for first argument, got " .. v4)

	local v5 = type(p2)

	assert(v5 == "number" and p2 % 1 == 0, "expected second argument to be an integer, got " .. v5)

	return p1[p2]
end

return get
