local function push(p1, ...) -- line: 2
	local v3 = type(p1)

	assert(v3 == "table", "expected a table for first argument, got " .. v3)

	local t1 = {}
	local v5 = #p1

	for i = 1, v5 do
		t1[i] = p1[i]
	end

	for i = 1, select("#", ...) do
		t1[v5 + i] = select(i, ...)
	end

	return t1
end

return push
