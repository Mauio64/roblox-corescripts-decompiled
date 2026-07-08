local function get(p1, p2) -- line: 2
	local v4 = type(p1)

	assert(v4 == "table", "expected a table for first argument, got " .. v4)
	assert(p2 ~= nil, "expected second argument to be anything but nil, got nil")

	return p1[p2]
end

return get
