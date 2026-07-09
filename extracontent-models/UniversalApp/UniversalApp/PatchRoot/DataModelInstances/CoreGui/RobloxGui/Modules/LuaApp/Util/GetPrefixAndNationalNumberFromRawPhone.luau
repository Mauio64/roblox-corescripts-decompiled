return function(s1: string) -- line: 11
	local v2 = s1:gsub("%D", "")

	if #v2 == 10 then
		return "1", v2
	end

	if #v2 == 11 and string.sub(v2, 1, 1) == "1" then
		return "1", (string.sub(v2, 2))
	end

	return "", v2
end
