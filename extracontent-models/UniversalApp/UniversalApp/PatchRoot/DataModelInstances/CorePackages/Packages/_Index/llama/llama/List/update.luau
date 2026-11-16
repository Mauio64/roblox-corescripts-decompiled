local copy = require(script.Parent.copy)

local function noUpdate(p)
	return p
end

local function call(callback, ...)
	if type(callback) == "function" then
		return callback(...)
	end
end

local function update(p, p2, p3, p4)
	local typeName = type(p)
	assert(typeName == "table", "expected a table for first argument, got " .. typeName)

	local typeName2 = type(p2)
	local v = typeName2 == "number" and p2 % 1 == 0
	assert(v, "expected an integer for second argument, got " .. typeName2)

	local v2 = copy(p)
	local v3 = p3 or noUpdate
	local v4

	if v2[p2] == nil then
		v4 = call(p4, false, p2)
	else
		v4 = v3(v2[p2], p2)
		call(p4, true, v4, p2)
	end

	v2[p2] = v4

	return v2
end

return update
