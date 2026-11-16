local function flatten(list)
	local typeName = type(list)
	assert(typeName == "table", "expected a table for first argument, got " .. typeName)

	local result = {}
	local v = 1

	for i = 1, #list do
		if type(list[i]) == "table" then
			local v2 = flatten(list[i])

			for j = 1, #v2 do
				result[v] = v2[j]
				v += 1
			end
		else
			result[v] = list[i]
			v += 1
		end
	end

	return result
end

return flatten
