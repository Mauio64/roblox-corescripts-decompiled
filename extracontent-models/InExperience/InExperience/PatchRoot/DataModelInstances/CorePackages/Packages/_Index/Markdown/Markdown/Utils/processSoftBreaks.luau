local function processSoftBreaks(s1: string) -- line: 5
	return (s1:gsub("%s*[\r\n]%s*", " "))
end

return processSoftBreaks
