local copy = require(script.Parent.copy)

local function sort(p, p2)
	local typeName = type(p)
	assert(typeName == "table", "expected a table for first argument, got " .. typeName)

	local v = copy(p)

	table.sort(v, p2)

	return v
end

return sort
