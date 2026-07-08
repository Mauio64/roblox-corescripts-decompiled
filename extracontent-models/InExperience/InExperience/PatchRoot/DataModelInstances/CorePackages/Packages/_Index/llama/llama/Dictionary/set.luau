local copy = require(script.Parent.copy)

local function set(p1, p2, p3) -- line: 4
	-- upvalues: copy (copy)
	local v6 = type(p1)

	assert(v6 == "table", "expected a table for first argument, got " .. v6)
	assert(p2 ~= nil, "expected second argument to be anything but nil, got nil")

	local v7 = copy(p1)

	v7[p2] = p3

	return v7
end

return set
