return function(value)
	if value == nil then
		error("cannot extract keys from a nil value")
	end

	local typeName = typeof(value)

	local result = {}

	if typeName == "table" then
		for k in pairs(value) do
			table.insert(result, k)
		end
	elseif typeName == "string" then
		for i = 1, value:len() do
			result[i] = tostring(i)
		end
	end

	return result
end
