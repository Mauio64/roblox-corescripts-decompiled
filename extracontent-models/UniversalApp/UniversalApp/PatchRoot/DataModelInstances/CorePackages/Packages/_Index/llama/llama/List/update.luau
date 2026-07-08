local copy = require(script.Parent.copy)

local function noUpdate(p1) -- line: 4
	return p1
end
local function call(p2, ...) -- line: 8
	if type(p2) == "function" then
		return p2(...)
	end
end
local function update(p3, p4, p5, p6) -- line: 14
	-- upvalues: copy (copy), noUpdate (copy), call (copy)
	local v11 = type(p3)

	assert(v11 == "table", "expected a table for first argument, got " .. v11)

	local v12 = type(p4)

	assert(v12 == "number" and p4 % 1 == 0, "expected an integer for second argument, got " .. v12)

	local v13 = copy(p3)
	local v14 = p5 or noUpdate
	local v15

	if v13[p4] ~= nil then
		v15 = v14(v13[p4], p4)
		call(p6, true, v15, p4)
	else
		v15 = call(p6, false, p4)
	end

	v13[p4] = v15

	return v13
end

return update
