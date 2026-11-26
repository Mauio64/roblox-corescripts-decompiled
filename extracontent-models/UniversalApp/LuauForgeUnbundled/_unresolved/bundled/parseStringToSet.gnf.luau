local function parseStringToSet(value)
	local stringToSet = {}

	for k in string.gmatch(value, "([^,]+)") do
		local v5 = k:gsub("^%s*(.-)%s*$", "%1")

		if v5 ~= "" then
			stringToSet[v5] = true
		end
	end

	return stringToSet
end

return parseStringToSet
