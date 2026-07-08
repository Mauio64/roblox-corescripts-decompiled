local function toList(p1) -- line: 2
	local t1 = {}
	local n1 = 1

	for k, _ in pairs(p1) do
		t1[n1] = k
		n1 += 1
	end

	return t1
end

return toList
