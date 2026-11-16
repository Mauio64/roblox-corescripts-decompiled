local function removeRange(list, p, p2)
	assert(p <= p2, "startIndex must be less than or equal to endIndex")

	local result = {}
	local v = 1

	for i = 1, math.min(#list, p - 1) do
		result[v] = list[i]
		v += 1
	end

	for i = p2 + 1, #list do
		result[v] = list[i]
		v += 1
	end

	return result
end

return removeRange
