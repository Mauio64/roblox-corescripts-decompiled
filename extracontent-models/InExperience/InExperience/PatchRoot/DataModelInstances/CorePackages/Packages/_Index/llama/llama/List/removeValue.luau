local toSet = require(script.Parent.Parent.List.toSet)

local function removeValue(p1, ...) -- line: 4
	-- upvalues: toSet (copy)
	local v4 = type(p1)

	assert(v4 == "table", "expected a table for first argument, got " .. v4)

	local v5 = toSet({ ... })
	local t1 = {}
	local n1 = 1

	for i = 1, #p1 do
		if not v5[p1[i]] then
			t1[n1] = p1[i]
			n1 += 1
		end
	end

	return t1
end

return removeValue
