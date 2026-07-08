local function startsWith(s1: string, s2: string) -- line: 16
	return s2 == s1:sub(1, s2:len())
end

return startsWith
