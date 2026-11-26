local function splitByNewlines(value)
	local result = {}

	for k in string.gmatch(value, "[^\n]+") do
		local v5 = string.match(k, "^%s*(.-)%s*$")

		if v5 and v5 ~= "" then
			table.insert(result, v5)
		end
	end

	return result
end

return splitByNewlines
