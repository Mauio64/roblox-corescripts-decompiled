local function matchesSearchQuery(value, value2): boolean
	if value2 == "" then
		return true
	end

	if value == nil or value == "" then
		return false
	end

	local v5 = string.lower(value2)
	local v6 = string.lower(value)
	return string.find(v6, v5, 1, true) ~= nil
end

return matchesSearchQuery
