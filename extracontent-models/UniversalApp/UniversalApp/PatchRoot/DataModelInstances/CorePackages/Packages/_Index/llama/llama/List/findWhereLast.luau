local function find(p1, p2, p3) -- line: 2
	local v5 = type(p1)

	assert(v5 == "table", "expected a table for first argument, got " .. v5)

	local v6 = type(p2)

	assert(v6 == "function", "expected a function for second argument, got " .. v6)

	for i = p3 or #p1, 1, -1 do
		if p2(p1[i], i) then
			return i
		end
	end

	return nil
end

return find
