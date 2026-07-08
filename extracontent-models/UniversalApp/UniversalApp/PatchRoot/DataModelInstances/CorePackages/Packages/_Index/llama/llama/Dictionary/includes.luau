local function includes(p1, p2) -- line: 2
	local v4 = type(p1)

	assert(v4 == "table", "expected a table for first argument, got " .. v4)

	for _, v in pairs(p1) do
		if v == p2 then
			return true
		end
	end

	return false
end

return includes
