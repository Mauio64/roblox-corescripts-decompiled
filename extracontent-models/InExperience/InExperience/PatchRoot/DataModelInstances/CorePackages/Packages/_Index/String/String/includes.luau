local v1 = "([" .. ("$%^()-[].?"):gsub("(.)", "%%%1") .. "])"

local function includes(s1: string, s2: string, p1) -- line: 20
	-- upvalues: v1 (copy)
	local v6, v7 = utf8.len(s1)

	assert(v6 ~= nil, ("string `%s` has an invalid byte at position %s"):format(s1, (tostring(v7))))

	if v6 == 0 then
		return false
	end

	if #s2 == 0 then
		return true
	end

	local n1 = 1

	if p1 ~= nil then
		n1 = tonumber(p1) or 1

		if v6 < n1 then
			return false
		end
	end

	if n1 < 1 then
		n1 = 1
	end

	local v9 = utf8.offset(s1, n1)
	local v10 = s2:gsub(v1, "%%%1")
	local start, _ = string.find(s1, v10, v9)

	return start ~= nil
end

return includes
