local function parseUserAllowList(s1: string?, n1: number) -- line: 7
	if not s1 or s1 == "" then
		return false
	end

	for _, v5 in string.split(s1, ",") do
		local v6 = v5:match("^%s*(.-)%s*$")

		if v6 and n1 == tonumber(v6) then
			return true
		end
	end

	return false
end

return parseUserAllowList
