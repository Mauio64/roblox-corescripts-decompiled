local function map(p1, p2) -- line: 4
	local t1 = {}

	for i = 1, #p1 do
		t1[i] = p2(p1[i], i)
	end

	return t1
end

return map
