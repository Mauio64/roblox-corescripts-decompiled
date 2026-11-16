local function splice(list, p, p2, ...)
	local typeName = type(list)
	assert(typeName == "table", "expected a table for first argument, got " .. typeName)

	local typeName2 = type(p)
	local v = typeName2 == "number" and p % 1 == 0
	assert(v, "expected an integer for second argument, got " .. typeName2)

	local typeName3 = type(p2)
	local v2 = typeName3 == "number" and p2 % 1 == 0
	assert(v2, "expected an integer for third argument, got " .. typeName3)

	assert(p <= p2, "start index must be less than or equal to end index")

	local count = #list

	local v3 = math.max(p, 1)
	local _ = math.min(v3, count)
	local result = {}
	local v4 = 1

	for i = 1, count do
		if i == v3 then
			for j = 1, select("#", ...) do
				result[v4] = select(j, ...)
				v4 += 1
			end
		else
			result[v4] = list[i]
			v4 += 1
		end
	end

	return result
end

return splice
