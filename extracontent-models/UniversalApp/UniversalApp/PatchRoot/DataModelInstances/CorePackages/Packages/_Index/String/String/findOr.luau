local v = "([" .. ("$%^()-[].?"):gsub("(.)", "%%%1") .. "])"

local function findOr(value: string, items, value2: number?)
	local v2 = utf8.offset(value, value2 or 1)
	local v3 = {}

	for _, item in items do
		local v4 = item:gsub(v, "%%%1")
		local v5, v6 = string.find(value, v4, v2)

		if not v5 then
			continue
		end

		local v7 = string.sub(value, 1, v5 - 1)
		local v8, v9 = utf8.len(v7)

		if v8 == nil then
			error(("string `%s` has an invalid byte at position %s"):format(v7, (tostring(v9))))
		end

		table.insert(v3, {
			index = v8 + 1,
			match = string.sub(value, v5, v6)
		})
	end

	if #v3 == 0 then
		return nil
	end

	local v4 = nil

	for _, v5 in v3 do
		if v4 == nil then
			v4 = v5
		end

		if v5.index < v4.index then
			v4 = v5
		end
	end

	return v4
end

return findOr
