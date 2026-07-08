local function removeRange(p1, p2, p3) -- line: 4
	assert(p2 <= p3, "startIndex must be less than or equal to endIndex")

	local t1 = {}
	local n1 = 1

	for i = 1, math.min(#p1, p2 - 1) do
		t1[n1] = p1[i]
		n1 += 1
	end

	for i = p3 + 1, #p1 do
		t1[n1] = p1[i]
		n1 += 1
	end

	return t1
end

return removeRange
