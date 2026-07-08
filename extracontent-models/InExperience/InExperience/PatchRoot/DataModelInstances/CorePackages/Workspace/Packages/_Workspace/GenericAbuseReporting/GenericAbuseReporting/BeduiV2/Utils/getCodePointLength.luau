local function getCodePointLength(s1: string) -- line: 1
	if s1 == nil then
		return 0
	end

	return utf8.len(s1) or s1:len()
end

return getCodePointLength
