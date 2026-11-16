local function toSet(list)
	local typeName = type(list)
	assert(typeName == "table", "expected a table for first argument, got " .. typeName)

	local set = {}

	for i = 1, #list do
		set[list[i]] = true
	end

	return set
end

return toSet
