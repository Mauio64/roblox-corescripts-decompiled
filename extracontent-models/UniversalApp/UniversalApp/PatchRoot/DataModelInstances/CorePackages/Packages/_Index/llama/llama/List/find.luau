local function find(list, p, value)
	local typeName = type(list)
	assert(typeName == "table", "expected a table for first argument, got " .. typeName)

	for i = value or 1, #list do
		if list[i] == p then
			return i
		end
	end

	return nil
end

return find
