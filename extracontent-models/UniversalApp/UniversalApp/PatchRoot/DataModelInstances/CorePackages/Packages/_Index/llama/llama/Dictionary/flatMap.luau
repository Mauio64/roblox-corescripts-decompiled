local join = require(script.Parent.join)

local function flatMap(p1, p2) -- line: 4
	-- upvalues: join (copy), flatMap (copy)
	local v5 = type(p1)

	assert(v5 == "table", "expected a table for first argument, got " .. v5)

	local v6 = type(p2)

	assert(v6 == "function", "expected a function for second argument, got " .. v6)

	local t1 = {}

	for k, v in pairs(p1) do
		if type(v) == "table" then
			t1 = join(flatMap(v, p2), t1)
		else
			local v10, v11 = p2(v, k)

			t1[v11 or k] = v10
		end
	end

	return t1
end

return flatMap
