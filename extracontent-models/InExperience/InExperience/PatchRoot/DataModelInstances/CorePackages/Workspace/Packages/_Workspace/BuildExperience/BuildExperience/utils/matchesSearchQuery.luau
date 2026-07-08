local function matchesSearchQuery(s1: string?, s2: string) -- line: 12
	if s2 == "" then
		return true
	end

	if s1 == nil or s1 == "" then
		return false
	end

	local v4 = string.lower(s2)
	local v5 = string.lower(s1)

	return string.find(v5, v4, 1, true) ~= nil
end

return matchesSearchQuery
