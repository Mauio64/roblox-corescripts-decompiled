local function roleNameToYear(value)
	local v5 = string.match(value, "^(%d%d%d%d)$")

	if v5 then
		return (tonumber(v5))
	end

	local v6 = string.match(value, "Class of (%d%d%d%d)")

	if v6 then
		return (tonumber(v6))
	end

	return nil
end

return roleNameToYear
