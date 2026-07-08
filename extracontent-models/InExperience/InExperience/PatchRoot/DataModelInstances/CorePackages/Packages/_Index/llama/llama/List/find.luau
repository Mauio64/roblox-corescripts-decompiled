local function find(p1, p2, p3) -- line: 2
	local v5 = type(p1)

	assert(v5 == "table", "expected a table for first argument, got " .. v5)

	for i = p3 or 1, #p1 do
		if p2 == p1[i] then
			return i
		end
	end

	return nil
end

return find
