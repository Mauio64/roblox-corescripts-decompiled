local function insert(p1, p2, ...) -- line: 2
	local v4 = type(p1)

	assert(v4 == "table", "expected a table for first argument, got " .. v4)

	local v5 = #p1

	assert(p2 >= 1 and p2 <= v5 + 1, "index must be in bounds of list")

	local t1 = {}
	local n1 = 1

	for i = 1, v5 do
		if i == p2 then
			for j = 1, select("#", ...) do
				t1[n1] = select(j, ...)
				n1 += 1
			end
		end

		t1[n1] = p1[i]
		n1 += 1
	end

	return t1
end

return insert
