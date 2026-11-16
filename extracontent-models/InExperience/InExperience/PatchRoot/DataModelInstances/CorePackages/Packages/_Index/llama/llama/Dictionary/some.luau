local function some(items, callback): boolean
	local typeName = type(callback)
	assert(typeName == "function", "expected a function for second argument, got " .. typeName)

	for k, item in pairs(items) do
		if callback(item, k) then
			return true
		end
	end

	return false
end

return some
