local function has(p, p2): boolean
	local typeName = type(p)
	assert(typeName == "table", "expected a table for first argument, got " .. typeName)

	assert(p2 ~= nil, "expected second argument to be anything but nil, got nil")

	return p[p2] == true
end

return has
