local function flatMap(list, callback)
	local typeName = type(list)
	assert(typeName == "table", "expected a table for first argument, got " .. typeName)

	local typeName2 = type(callback)
	assert(typeName2 == "function", "expected a function for second argument, got " .. typeName2)

	local result = {}
	local v = 1

	for i = 1, #list do
		if type(list[i]) == "table" then
			local v2 = flatMap(list[i], callback)

			for j = 1, #v2 do
				result[v] = v2[j]
				v += 1
			end
		else
			local v2 = callback(list[i], i)

			if v2 ~= nil then
				result[v] = v2
				v += 1
			end
		end
	end

	return result
end

return flatMap
