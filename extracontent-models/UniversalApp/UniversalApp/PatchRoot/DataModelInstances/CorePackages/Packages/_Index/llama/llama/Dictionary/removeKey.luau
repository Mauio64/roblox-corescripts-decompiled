local copy = require(script.Parent.copy)

local function removeKey(p1, ...) -- line: 4
	-- upvalues: copy (copy)
	local v4 = type(p1)

	assert(v4 == "table", "expected a table for first argument, got " .. v4)

	local v5 = copy(p1)

	for i = 1, select("#", ...) do
		v5[select(i, ...)] = nil
	end

	return v5
end

return removeKey
