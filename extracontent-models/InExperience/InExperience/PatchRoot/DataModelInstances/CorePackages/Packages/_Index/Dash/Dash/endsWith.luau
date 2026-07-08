local function endsWith(s1: string, s2: string) -- line: 14
	return s2 == s1:sub(-s2:len())
end

return endsWith
