local function getRange(p1, p2, p3) -- line: 5
	assert(p2 <= p3, "startIndex must be less than or equal to endIndex")

	local t1 = {}
	local n1 = 1

	for i = math.max(1, p2), math.min(#p1, p3) do
		t1[n1] = p1[i]
		n1 += 1
	end

	return t1
end

return getRange
