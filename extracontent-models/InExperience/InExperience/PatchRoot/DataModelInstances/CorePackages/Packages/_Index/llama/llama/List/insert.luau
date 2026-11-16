local function insert(list, p, ...)
	local typeName = type(list)
	assert(typeName == "table", "expected a table for first argument, got " .. typeName)

	local count = #list
	local v = p >= 1 and p <= count + 1
	assert(v, "index must be in bounds of list")

	local result = {}
	local v2 = 1

	for i = 1, count do
		if i == p then
			for j = 1, select("#", ...) do
				result[v2] = select(j, ...)
				v2 += 1
			end
		end

		result[v2] = list[i]
		v2 += 1
	end

	return result
end

return insert
