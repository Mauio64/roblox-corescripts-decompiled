local function computeEditDistance(s1: string, s2: string) -- line: 2
	if s1 == s2 then
		return 0
	end

	local v4 = #s1
	local v5 = #s2

	if v4 == 0 then
		return v5
	end

	if v5 == 0 then
		return v4
	end

	if v4 < v5 then
		local v6 = s1

		s1 = s2

		local v7 = v4

		v4 = v5
		s2 = v6
		v5 = v7
	end

	local t1 = table.create(v5 + 1)
	local t2 = table.create(v5 + 1)

	for i = 0, v5 do
		t1[i + 1] = i
	end

	for i = 1, v4 do
		t2[1] = i

		local byte = string.byte(s1, i)

		for j = 1, v5 do
			local v14 = byte ~= string.byte(s2, j) and 1 or 0
			local v15 = t1[j + 1] + 1
			local v16 = t2[j] + 1
			local v17 = t1[j] + v14

			if v16 < v15 then
				v15 = v16
			end

			if v17 < v15 then
				v15 = v17
			end

			t2[j + 1] = v15
		end

		local v18 = t1

		t1 = t2
		t2 = v18
	end

	return t1[v5 + 1]
end

return computeEditDistance
