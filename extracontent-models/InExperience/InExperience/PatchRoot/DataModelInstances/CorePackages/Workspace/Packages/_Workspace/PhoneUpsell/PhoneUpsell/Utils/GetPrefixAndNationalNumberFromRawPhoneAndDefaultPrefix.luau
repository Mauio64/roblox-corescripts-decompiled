return function(s1: string, s2: string) -- line: 1
	local v3 = s1:gsub("%D", "")
	local v4 = s2:gsub("%D", "")

	if string.find(v3, v4) == 1 then
		return s2, (string.sub(v3, string.len(v4) + 1))
	end

	return s2, v3
end
