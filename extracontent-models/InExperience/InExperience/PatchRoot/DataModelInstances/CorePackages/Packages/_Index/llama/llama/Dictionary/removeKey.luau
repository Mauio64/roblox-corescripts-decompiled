local copy = require(script.Parent.copy)

local function removeKey(p, ...)
	local typeName = type(p)
	assert(typeName == "table", "expected a table for first argument, got " .. typeName)

	local result = copy(p)

	for i = 1, select("#", ...) do
		result[select(i, ...)] = nil
	end

	return result
end

return removeKey
