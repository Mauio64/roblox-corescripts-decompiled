local function every(list, callback): boolean
	local typeName = type(list)
	assert(typeName == "table", "expected a table for first argument, got " .. typeName)

	local typeName2 = type(callback)
	assert(typeName2 == "function", "expected a function for second argument, got " .. typeName2)

	for i = 1, #list do
		if not callback(list[i], i) then
			return false
		end
	end

	return true
end

return every
