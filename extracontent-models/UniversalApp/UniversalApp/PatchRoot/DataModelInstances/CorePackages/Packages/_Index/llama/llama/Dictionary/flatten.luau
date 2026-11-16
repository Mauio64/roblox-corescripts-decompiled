local join = require(script.Parent.join)
local function flatten(item)
	local typeName = type(item)
	assert(typeName == "table", "expected a table for first argument, got " .. typeName)

	local result = {}

	for k, item2 in pairs(item) do
		if type(item2) == "table" then
			result = join(flatten(item2), result)
		else
			result[k] = item2
		end
	end

	return result
end

return flatten
