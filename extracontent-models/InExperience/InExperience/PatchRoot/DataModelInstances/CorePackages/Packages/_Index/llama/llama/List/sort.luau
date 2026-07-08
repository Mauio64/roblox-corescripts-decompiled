local copy = require(script.Parent.copy)

local function sort(p1, p2) -- line: 4
	-- upvalues: copy (copy)
	local v5 = type(p1)

	assert(v5 == "table", "expected a table for first argument, got " .. v5)

	local v6 = copy(p1)

	table.sort(v6, p2)

	return v6
end

return sort
