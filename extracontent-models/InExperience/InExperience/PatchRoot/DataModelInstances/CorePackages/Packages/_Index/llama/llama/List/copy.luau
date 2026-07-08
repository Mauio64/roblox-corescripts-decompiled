local function copy(p1) -- line: 2
	local v3 = type(p1)

	assert(v3 == "table", "expected a table for first argument, got " .. v3)

	local t1 = {}

	for i = 1, #p1 do
		t1[i] = p1[i]
	end

	return t1
end

return copy
