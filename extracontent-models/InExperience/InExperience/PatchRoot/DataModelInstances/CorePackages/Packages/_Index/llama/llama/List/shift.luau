local function shift(p1, p2) -- line: 2
	local v4 = type(p1)

	assert(v4 == "table", "expected a table for first argument, got " .. v4)

	local v5 = p2 or 1
	local v6 = type(v5)

	assert(v6 == "number" and v5 % 1 == 0, "expected an integer for second argument, got " .. v6)

	local t1 = {}

	for i = 1 + v5, #p1 do
		t1[i - v5] = p1[i]
	end

	return t1
end

return shift
