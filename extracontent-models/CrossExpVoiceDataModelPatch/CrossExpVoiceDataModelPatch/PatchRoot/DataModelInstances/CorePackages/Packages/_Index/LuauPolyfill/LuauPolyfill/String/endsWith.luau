local function endsWith(s1: string, s2: string, n1: number?) -- line: 2
	local v5 = s2:len()

	if v5 == 0 then
		return true
	end

	local v6 = s1:len()
	local v7 = n1 or v6

	if v6 < v7 then
		v7 = v6
	end

	if v7 < 1 then
		return false
	end

	local v8 = v7 - v5 + 1

	return v8 == s1:find(s2, v8, true)
end

return endsWith
