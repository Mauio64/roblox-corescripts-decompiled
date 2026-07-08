local function every(p1, p2) -- line: 2
	local v4 = type(p1)

	assert(v4 == "table", "expected a table for first argument, got " .. v4)

	local v5 = type(p2)

	assert(v5 == "function", "expected a function for second argument, got " .. v5)

	for k, v in pairs(p1) do
		if not p2(v, k) then
			return false
		end
	end

	return true
end

return every
