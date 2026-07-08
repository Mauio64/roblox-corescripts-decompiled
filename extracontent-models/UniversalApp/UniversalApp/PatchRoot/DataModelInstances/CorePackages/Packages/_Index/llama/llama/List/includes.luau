local function includes(p1, p2) -- line: 2
	local v4 = type(p1)

	assert(v4 == "table", "expected a table for first argument, got " .. v4)

	for i = 1, #p1 do
		if p2 == p1[i] then
			return true
		end
	end

	return false
end

return includes
