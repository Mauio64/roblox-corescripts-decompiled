local function getFetchName(s1: string, s2: string) -- line: 1
	return `search.{ s1 }.{ s2 }`
end

return getFetchName
