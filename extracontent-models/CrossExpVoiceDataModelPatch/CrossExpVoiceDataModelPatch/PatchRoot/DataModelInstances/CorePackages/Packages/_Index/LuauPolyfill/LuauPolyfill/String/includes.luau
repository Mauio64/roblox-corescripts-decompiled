local v = "([" .. ("$%^()-[].?"):gsub("(.)", "%%%1") .. "])"

local function includes(value: string, value2: string, p): boolean
	local v2, v3 = utf8.len(value)
	assert(v2 ~= nil, ("string `%s` has an invalid byte at position %s"):format(value, (tostring(v3))))

	if v2 == 0 then
		return false
	end

	if #value2 == 0 then
		return true
	end

	local v4

	if p == nil then
		v4 = 1
	else
		v4 = tonumber(p) or 1

		if v2 < v4 then
			return false
		end
	end

	local v5 = v4 < 1 and 1 or v4

	local v6 = utf8.offset(value, v5)
	local v7 = value2:gsub(v, "%%%1")
	local v8, _ = string.find(value, v7, v6)
	return v8 ~= nil
end

return includes
