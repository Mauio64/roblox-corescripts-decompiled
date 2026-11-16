local function includes(items, p): boolean
	local typeName = type(items)
	assert(typeName == "table", "expected a table for first argument, got " .. typeName)

	for _, item in pairs(items) do
		if item == p then
			return true
		end
	end

	return false
end

return includes
