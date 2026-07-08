local function sort(p1, p2) -- line: 6
	local t1 = {}

	for i = 1, #p1 do
		t1[i] = p1[i]
	end

	table.sort(t1, p2)

	return t1
end

return sort
