local function getRange(list, p, p2)
	assert(p <= p2, "startIndex must be less than or equal to endIndex")

	local range = {}
	local v = 1

	for i = math.max(1, p), math.min(#list, p2) do
		range[v] = list[i]
		v += 1
	end

	return range
end

return getRange
