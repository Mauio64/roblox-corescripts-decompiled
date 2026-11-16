require(script.Parent.Parent.types)

return function(value)
	assert(value ~= nil, "cannot get entries from a nil value")
	local typeName = typeof(value)

	local result = {}

	if typeName == "table" then
		for k, v in pairs(value) do
			table.insert(result, { k, v })
		end
	elseif typeName == "string" then
		for i = 1, string.len(value) do
			result[i] = { tostring(i), (string.sub(value, i, i)) }
		end
	end

	return result
end
