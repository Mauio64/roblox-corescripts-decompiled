function cleanUsernameForSuggestions(s1: string) -- line: 1
	local v2 = s1:gsub("[^%w_]", "")

	if string.sub(v2, 1, 1) == "_" then
		v2 = v2:sub(2)
	end

	if string.sub(v2, -1) == "_" then
		v2 = v2:sub(1, -2)
	end

	local v3 = string.find(v2, "_")

	if v3 and v3 < #v2 then
		v2 = v2:sub(1, v3) .. string.gsub(v2:sub(v3 + 1), "_", "")
	end

	if #v2 >= 20 then
		v2 = v2:sub(1, 18)
	end

	return v2
end

return cleanUsernameForSuggestions
