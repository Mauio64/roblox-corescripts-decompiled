local function startsWith(s1: string, s2: string, n1: number?) -- line: 2
	if string.len(s2) == 0 then
		return true
	end

	local v5 = if n1 ~= nil and not (n1 < 1) then n1 else 1

	if v5 > string.len(s1) then
		return false
	end

	return v5 == s1:find(s2, v5, true)
end

return startsWith
