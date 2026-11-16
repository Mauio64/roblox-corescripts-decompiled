local function flip(items)
	local typeName = type(items)
	assert(typeName == "table", "expected a table for first argument, got " .. typeName)

	local result = {}

	for k, item in pairs(items) do
		result[item] = k
	end

	return result
end

return flip
