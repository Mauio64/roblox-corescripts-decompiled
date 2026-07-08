return function(s1: string) -- line: 4
	return string.sub(s1, 1, 7) == "Enabled" or s1 == "AllUsers"
end
