local function some(p1, p2) -- line: 2
	local v4 = type(p2)

	assert(v4 == "function", "expected a function for second argument, got " .. v4)

	for k, v in pairs(p1) do
		if p2(v, k) then
			return true
		end
	end

	return false
end

return some
