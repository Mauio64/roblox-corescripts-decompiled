local function normalizeKeyword(s1: string, b1: boolean?) -- line: 5
	local v4 = s1:gsub("\239\191\188", ""):gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", "")

	if b1 then
		v4 = v4:lower()
	end

	return v4
end

return normalizeKeyword
