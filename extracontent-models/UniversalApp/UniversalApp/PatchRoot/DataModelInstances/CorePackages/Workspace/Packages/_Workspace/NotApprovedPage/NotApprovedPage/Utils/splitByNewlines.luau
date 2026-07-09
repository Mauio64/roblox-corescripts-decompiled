local function splitByNewlines(s1: string) -- line: 4
	local t1 = {}

	for match in string.gmatch(s1, "[^\n]+") do
		local match2 = string.match(match, "^%s*(.-)%s*$")

		if match2 and match2 ~= "" then
			table.insert(t1, match2)
		end
	end

	return t1
end

return splitByNewlines
