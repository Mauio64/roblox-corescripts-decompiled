local toSet = require(script.Parent.Parent.List.toSet)

local function removeValue(list, ...)
	local typeName = type(list)
	assert(typeName == "table", "expected a table for first argument, got " .. typeName)

	local v = toSet({ ... })
	local result = {}
	local v2 = 1

	for i = 1, #list do
		if v[list[i]] then
			continue
		end

		result[v2] = list[i]
		v2 += 1
	end

	return result
end

return removeValue
