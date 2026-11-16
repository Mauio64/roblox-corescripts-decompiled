local function includes(list, p): boolean
	local typeName = type(list)
	assert(typeName == "table", "expected a table for first argument, got " .. typeName)

	for i = 1, #list do
		if list[i] == p then
			return true
		end
	end

	return false
end

return includes
