return function(s1: string) -- line: 1
	return s1 ~= nil and (s1 ~= "" and tonumber(s1) > 0)
end
