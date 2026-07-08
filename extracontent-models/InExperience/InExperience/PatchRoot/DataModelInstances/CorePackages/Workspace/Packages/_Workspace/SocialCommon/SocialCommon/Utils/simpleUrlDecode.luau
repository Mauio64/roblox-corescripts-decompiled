return function(s1: string) -- line: 2
	return (s1:gsub("+", " "):gsub("%%(%x%x)", function(p1) -- line: 3
		return (string.char((tonumber(p1, 16))))
	end))
end
