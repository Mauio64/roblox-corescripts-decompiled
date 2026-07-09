return function(s1: string) -- line: 4
	return string.gmatch(s1 or "", "([^,]+)")
end
