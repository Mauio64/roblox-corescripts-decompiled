local function cleanText(s1: string) -- line: 1
	return (s1:gsub("[^ -~\n]", ""))
end

return cleanText
