local join = require(script.Parent.join)
local function flatMap(item, callback)
	local typeName = type(item)
	assert(typeName == "table", "expected a table for first argument, got " .. typeName)

	local typeName2 = type(callback)
	assert(typeName2 == "function", "expected a function for second argument, got " .. typeName2)

	local result = {}

	for k, item2 in pairs(item) do
		if type(item2) == "table" then
			result = join(flatMap(item2, callback), result)
		else
			local v, v2 = callback(item2, k)

			result[v2 or k] = v
		end
	end

	return result
end

return flatMap
