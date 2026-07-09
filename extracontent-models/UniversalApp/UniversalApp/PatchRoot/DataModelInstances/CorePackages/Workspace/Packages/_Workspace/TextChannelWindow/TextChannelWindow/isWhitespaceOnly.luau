local function isWhitespaceOnly(s1: string) -- line: 1
	return string.find(s1, "%S") == nil
end

return isWhitespaceOnly
