local function map(p1, p2) -- line: 2
	local v4 = type(p1)

	assert(v4 == "table", "expected a table for first argument, got " .. v4)

	local v5 = type(p2)

	assert(v5 == "function", "expected a function for second argument, got " .. v5)

	local t1 = {}

	for k, v in pairs(p1) do
		local v9, v10 = p2(v, k)

		t1[v10 or k] = v9
	end

	return t1
end

return map
