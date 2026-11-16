local function matchesSearchQuery(value: string?, value2: string): boolean
	if value2 == "" then
		return true
	end

	if value == nil or value == "" then
		return false
	end

	local v = string.lower(value2)
	local v2 = string.lower(value)
	return string.find(v2, v, 1, true) ~= nil
end

return matchesSearchQuery
