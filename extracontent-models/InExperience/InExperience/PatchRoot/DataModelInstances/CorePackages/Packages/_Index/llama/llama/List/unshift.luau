local function unshift(p1, ...) -- line: 2
	local v3 = type(p1)

	assert(v3 == "table", "expected a table for first argument, got " .. v3)

	local v4 = select("#", ...)
	local t1 = {}

	for i = 1, v4 do
		t1[i] = select(i, ...)
	end

	for i = 1, #p1 do
		t1[v4 + i] = p1[i]
	end

	return t1
end

return unshift
