local function reverse(p1) -- line: 2
	local v3 = type(p1)

	assert(v3 == "table", "expected a table for first argument, got " .. v3)

	local t1 = {}
	local v5 = #p1
	local v6 = v5 + 1

	for i = 1, v5 do
		t1[i] = p1[v6 - i]
	end

	return t1
end

return reverse
