local function parseUserAllowList(value: string?, p: number): boolean
	if not value or value == "" then
		return false
	end

	for _, v in string.split(value, ",") do
		local match = v:match("^%s*(.-)%s*$")

		if match and tonumber(match) == p then
			return true
		end
	end

	return false
end

return parseUserAllowList
