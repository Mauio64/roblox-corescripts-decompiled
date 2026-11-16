local function find(list, p, p2)
	local typeName = type(list)
	assert(typeName == "table", "expected a table for first argument, got " .. typeName)

	for i = p2 or #list, 1, -1 do
		if list[i] == p then
			return i
		end
	end

	return nil
end

return find
