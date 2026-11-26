local function parseUserAllowList(value, p2): boolean
	if not value or value == "" then
		return false
	end

	for k, v5 in string.split(value, ",") do
		local match = v5:match("^%s*(.-)%s*$")

		if match and tonumber(match) == p2 then
			return true
		end
	end

	return false
end

return parseUserAllowList
