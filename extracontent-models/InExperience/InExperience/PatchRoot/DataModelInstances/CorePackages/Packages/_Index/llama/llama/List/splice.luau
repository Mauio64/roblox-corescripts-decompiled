local function splice(p1, p2, p3, ...) -- line: 2
	local v5 = type(p1)

	assert(v5 == "table", "expected a table for first argument, got " .. v5)

	local v6 = type(p2)

	assert(v6 == "number" and p2 % 1 == 0, "expected an integer for second argument, got " .. v6)

	local v7 = type(p3)

	assert(v7 == "number" and p3 % 1 == 0, "expected an integer for third argument, got " .. v7)
	assert(p2 <= p3, "start index must be less than or equal to end index")

	local t1 = {}
	local n1 = 1
	local v10 = #p1
	local v11 = math.max(p2, 1)

	math.min(v11, v10)

	for i = 1, v10 do
		local v13 = i

		if v13 == v11 then
			for j = 1, select("#", ...) do
				t1[n1] = select(j, ...)
				n1 += 1
			end
		else
			t1[n1] = p1[v13]
			n1 += 1
		end
	end

	return t1
end

return splice
