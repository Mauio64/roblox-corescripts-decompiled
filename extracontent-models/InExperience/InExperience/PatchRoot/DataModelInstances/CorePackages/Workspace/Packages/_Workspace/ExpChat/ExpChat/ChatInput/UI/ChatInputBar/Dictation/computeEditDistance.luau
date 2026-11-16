local function computeEditDistance(value: string, value2: string)
	if value == value2 then
		return 0
	end

	local v = #value
	local v2 = #value2

	if v == 0 then
		return v2
	end

	if v2 == 0 then
		return v
	end

	if v < v2 then
		local v3 = value2
		value2 = value
		value = v3
		v3 = v
		v = v2
		v2 = v3
	end

	local v3 = table.create(v2 + 1)
	local v4 = table.create(v2 + 1)

	for i = 0, v2 do
		v3[i + 1] = i
	end

	for i = 1, v do
		v4[1] = i
		local v5 = string.byte(value, i)

		for j = 1, v2 do
			local v6 = v5 == string.byte(value2, j) and 0 or 1
			local v7 = v3[j + 1] + 1
			local v8 = v4[j] + 1
			local v9 = v3[j] + v6

			if v8 < v7 then
				v7 = v8
			end

			if v9 < v7 then
				v7 = v9
			end

			v4[j + 1] = v7
		end

		v3, v4 = v4, v3
	end

	return v3[v2 + 1]
end

return computeEditDistance
