local function slice(p1, p2, p3) -- line: 2
	local v5 = type(p1)

	assert(v5 == "table", "expected a table for first argument, got " .. v5)

	local v6 = #p1
	local v7 = p2 or 1
	local v8 = p3 or v6

	assert(v7 <= v8, "start index must be less than or equal to end index")

	local t1 = {}
	local n1 = 1

	for i = math.max(1, v7), math.min(v8, v6) do
		t1[n1] = p1[i]
		n1 += 1
	end

	return t1
end

return slice
