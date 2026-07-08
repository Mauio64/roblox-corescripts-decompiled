return function(s1: string, n1: number, n2: number?) -- line: 2
	if n2 and n2 <= 0 then
		return ""
	end

	return (string.sub(s1, n1, n2 and n1 + n2 - 1 or nil))
end
