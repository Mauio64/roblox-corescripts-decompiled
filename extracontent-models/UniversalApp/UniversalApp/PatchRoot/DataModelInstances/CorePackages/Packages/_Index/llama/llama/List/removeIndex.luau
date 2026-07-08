local toSet = require(script.Parent.toSet)

local function removeIndex(p1, ...) -- line: 4
	-- upvalues: toSet (copy)
	local v4 = type(p1)

	assert(v4 == "table", "expected a table for first argument, got " .. v4)

	local t1 = {}
	local v6 = toSet({ ... })
	local n1 = 1

	for i = 1, #p1 do
		if not v6[i] then
			t1[n1] = p1[i]
			n1 += 1
		end
	end

	return t1
end

return removeIndex
