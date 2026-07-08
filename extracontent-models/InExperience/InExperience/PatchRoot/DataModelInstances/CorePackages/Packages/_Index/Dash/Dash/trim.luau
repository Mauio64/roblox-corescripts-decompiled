local function trim(s1: string) -- line: 7
	return (s1:match("^%s*(.-)%s*$"))
end

return trim
