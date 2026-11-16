local function normalizeKeyword(value, p2)
	local keyword = value:gsub("￼", ""):gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", "")

	if p2 then
		keyword = keyword:lower()
	end

	return keyword
end

return normalizeKeyword
