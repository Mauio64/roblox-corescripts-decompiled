local function zip(...) -- line: 2
	local t1 = {}
	local v3 = select("#", ...)
	local v4 = #select(1, ...)

	for i = 2, v3 do
		local v6 = #select(i, ...)

		if v6 < v4 then
			v4 = v6
		end
	end

	for i = 1, v4 do
		t1[i] = {}

		for j = 1, v3 do
			t1[i][j] = select(j, ...)[i]
		end
	end

	return t1
end

return zip
