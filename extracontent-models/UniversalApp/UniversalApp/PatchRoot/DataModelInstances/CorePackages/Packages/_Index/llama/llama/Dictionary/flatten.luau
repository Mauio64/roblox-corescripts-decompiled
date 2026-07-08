local join = require(script.Parent.join)

local function flatten(p1) -- line: 4
	-- upvalues: join (copy), flatten (copy)
	local v4 = type(p1)

	assert(v4 == "table", "expected a table for first argument, got " .. v4)

	local t1 = {}

	for k, v in pairs(p1) do
		if type(v) == "table" then
			t1 = join(flatten(v), t1)
		else
			t1[k] = v
		end
	end

	return t1
end

return flatten
