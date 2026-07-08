local function flip(p1) -- line: 2
	local v3 = type(p1)

	assert(v3 == "table", "expected a table for first argument, got " .. v3)

	local t1 = {}

	for k, v in pairs(p1) do
		t1[v] = k
	end

	return t1
end

return flip
