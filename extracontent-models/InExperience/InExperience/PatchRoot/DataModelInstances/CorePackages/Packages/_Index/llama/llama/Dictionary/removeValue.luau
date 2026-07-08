local toSet = require(script.Parent.Parent.List.toSet)

local function removeValues(p1, ...) -- line: 4
	-- upvalues: toSet (copy)
	local v4 = type(p1)

	assert(v4 == "table", "expected a table for first argument, got " .. v4)

	local v5 = toSet({ ... })
	local t1 = {}

	for k, v in pairs(p1) do
		if not v5[v] then
			t1[k] = v
		end
	end

	return t1
end

return removeValues
