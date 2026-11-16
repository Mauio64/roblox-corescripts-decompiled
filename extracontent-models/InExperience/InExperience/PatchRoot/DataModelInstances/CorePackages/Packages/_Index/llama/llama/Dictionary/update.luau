local copy = require(script.Parent.copy)

local function noUpdate(p, p2)
	return p, p2
end

local function call(callback, ...)
	if type(callback) == "function" then
		return callback(...)
	end
end

local function update(p, p2, p3, p4)
	local typeName = type(p)
	assert(typeName == "table", "expected a table for first argument, got " .. typeName)

	assert(p2 ~= nil, "expected second argument to be anything but nil, got nil")

	local v = copy(p)
	local v2 = p3 or noUpdate
	local v3, v4

	if v[p2] == nil then
		v3, v4 = call(p4, false, p2)
	else
		v3, v4 = v2(v[p2], p2)
		call(p4, true, v3, v4 or p2)
	end

	v[v4 or p2] = v3

	return v
end

return update
