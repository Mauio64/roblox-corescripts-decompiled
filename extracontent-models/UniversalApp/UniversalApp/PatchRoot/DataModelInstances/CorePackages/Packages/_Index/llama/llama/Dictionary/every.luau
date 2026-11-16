local function every(items, callback): boolean
	local typeName = type(items)
	assert(typeName == "table", "expected a table for first argument, got " .. typeName)

	local typeName2 = type(callback)
	assert(typeName2 == "function", "expected a function for second argument, got " .. typeName2)

	for k, item in pairs(items) do
		if not callback(item, k) then
			return false
		end
	end

	return true
end

return every
