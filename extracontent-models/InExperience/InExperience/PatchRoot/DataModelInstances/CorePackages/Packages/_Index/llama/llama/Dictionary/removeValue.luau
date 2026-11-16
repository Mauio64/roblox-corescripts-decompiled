local toSet = require(script.Parent.Parent.List.toSet)

local function removeValues(items, ...)
	local typeName = type(items)
	assert(typeName == "table", "expected a table for first argument, got " .. typeName)

	local v = toSet({ ... })
	local result = {}

	for k, item in pairs(items) do
		if not v[item] then
			result[k] = item
		end
	end

	return result
end

return removeValues
