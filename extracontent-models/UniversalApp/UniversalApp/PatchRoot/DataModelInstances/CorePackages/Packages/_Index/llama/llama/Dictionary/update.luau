local copy = require(script.Parent.copy)

local function noUpdate(p1, p2) -- line: 4
	return p1, p2
end
local function call(p3, ...) -- line: 8
	if type(p3) == "function" then
		return p3(...)
	end
end
local function update(p4, p5, p6, p7) -- line: 14
	-- upvalues: copy (copy), noUpdate (copy), call (copy)
	local v12 = type(p4)

	assert(v12 == "table", "expected a table for first argument, got " .. v12)
	assert(p5 ~= nil, "expected second argument to be anything but nil, got nil")

	local v13 = copy(p4)
	local v14 = p6 or noUpdate
	local v15, v16

	if v13[p5] ~= nil then
		v15, v16 = v14(v13[p5], p5)
		call(p7, true, v15, v16 or p5)
	else
		v15, v16 = call(p7, false, p5)
	end

	v13[v16 or p5] = v15

	return v13
end

return update
