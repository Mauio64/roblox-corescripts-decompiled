local parent = script.Parent.Parent.Parent

require(parent.ES7Types)

return function(value)
	if value == nil then
		error("cannot extract values from a nil value")
	end

	local typeName = typeof(value)

	local result = nil

	if typeName == "table" then
		local result2 = {}

		for _, v in pairs(value) do
			table.insert(result2, v)
		end

		return result2
	else
		if typeName ~= "string" then
			return result
		end

		local v = value:len()
		result = table.create(v)

		for i = 1, v do
			result[i] = value:sub(i, i)
		end

		return result
	end
end
