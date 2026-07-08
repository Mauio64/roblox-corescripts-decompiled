local function replaceIndex(p1, p2, p3) -- line: 5
	local t1 = {}
	local v6 = #p1

	assert(p2 <= v6, "index must be less or equal than the list length")

	for i = 1, v6 do
		if i == p2 then
			t1[i] = p3
		else
			t1[i] = p1[i]
		end
	end

	return t1
end

return replaceIndex
