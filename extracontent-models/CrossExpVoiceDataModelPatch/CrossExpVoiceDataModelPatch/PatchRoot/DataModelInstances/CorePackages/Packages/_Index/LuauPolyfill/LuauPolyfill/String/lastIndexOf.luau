local function lastIndexOf(s1: string, s2: string, n1: number?) -- line: 2
	local v5 = string.len(s1)
	local v6 = n1 or v5

	if n1 and n1 < 1 then
		v6 = 1
	end

	if n1 and v5 < n1 then
		v6 = v5
	end

	if s2 == "" then
		return v6
	end

	local start = nil
	local n2 = 0
	local v9

	repeat
		v9 = start
		start, n2 = string.find(s1, s2, n2 + 1, true)
	until start == nil or v6 < start

	if v9 == nil then
		return -1
	end

	return v9
end

return lastIndexOf
