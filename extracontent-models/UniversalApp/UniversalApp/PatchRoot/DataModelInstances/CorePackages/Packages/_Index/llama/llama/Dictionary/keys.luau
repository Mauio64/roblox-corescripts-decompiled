local function keys(p1) -- line: 2
	local v3 = type(p1)

	assert(v3 == "table", "expected a table for first argument, got " .. v3)

	local t1 = {}
	local n1 = 1

	for k, _ in pairs(p1) do
		t1[n1] = k
		n1 += 1
	end

	return t1
end

return keys
