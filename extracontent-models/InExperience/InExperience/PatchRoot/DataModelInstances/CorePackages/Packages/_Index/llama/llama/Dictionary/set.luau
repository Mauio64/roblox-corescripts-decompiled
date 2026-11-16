local copy = require(script.Parent.copy)

local function set(p, p2, p3)
	local typeName = type(p)
	assert(typeName == "table", "expected a table for first argument, got " .. typeName)

	assert(p2 ~= nil, "expected second argument to be anything but nil, got nil")

	local v = copy(p)

	v[p2] = p3

	return v
end

return set
