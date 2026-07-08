local function set(p1, p2, p3) -- line: 2
	local v5 = type(p1)

	assert(v5 == "table", "expected a table for first argument, got " .. v5)

	local v6 = #p1

	assert(p2 <= v6, "index must be less than or equal to the list length")
	assert(p2 >= 1, "index must be greater than or equal to 1")

	local t1 = {}
	local n1 = 1

	for i = 1, v6 do
		if i == p2 then
			t1[n1] = p3
		else
			t1[n1] = p1[i]
		end

		n1 += 1
	end

	return t1
end

return set
