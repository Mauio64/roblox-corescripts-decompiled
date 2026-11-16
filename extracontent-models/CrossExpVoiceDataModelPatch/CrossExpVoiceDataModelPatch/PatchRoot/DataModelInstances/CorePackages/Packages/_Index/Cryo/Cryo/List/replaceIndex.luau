local function replaceIndex(list, p, p2)
	local count = #list

	assert(p <= count, "index must be less or equal than the list length")
	local result = {}

	for i = 1, count do
		if i == p then
			result[i] = p2
		else
			result[i] = list[i]
		end
	end

	return result
end

return replaceIndex
