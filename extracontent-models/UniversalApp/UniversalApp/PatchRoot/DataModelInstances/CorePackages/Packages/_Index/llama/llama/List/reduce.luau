local function reduce(p1, p2, p3) -- line: 2
	local v5 = type(p1)

	assert(v5 == "table", "expected a table for first argument, got " .. v5)

	local v6 = type(p2)

	assert(v6 == "function", "expected a function for second argument, got " .. v6)

	local v7 = p3

	if v7 == nil then
		v7 = p1[1]
	end

	for i = p3 ~= nil and 1 or 2, #p1 do
		v7 = p2(v7, p1[i], i)
	end

	return v7
end

return reduce
