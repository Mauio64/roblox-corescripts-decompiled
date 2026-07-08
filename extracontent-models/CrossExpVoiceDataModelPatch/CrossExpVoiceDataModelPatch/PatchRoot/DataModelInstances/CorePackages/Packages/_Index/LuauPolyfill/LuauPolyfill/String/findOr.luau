local v1 = "([" .. ("$%^()-[].?"):gsub("(.)", "%%%1") .. "])"

local function findOr(s1: string, t1: {[any]: any}, n1: number?) -- line: 10
	-- upvalues: v1 (copy)
	local v6 = utf8.offset(s1, n1 or 1)
	local t2 = {}

	for _, v9 in t1 do
		local v10 = v9:gsub(v1, "%%%1")
		local start, stop = string.find(s1, v10, v6)

		if start then
			local v13 = string.sub(s1, 1, start - 1)
			local v14, v15 = utf8.len(v13)

			if v14 == nil then
				error(("string `%s` has an invalid byte at position %s"):format(v13, (tostring(v15))))
			end

			table.insert(t2, {
				index = v14 + 1,
				match = string.sub(s1, start, stop)
			})
		end
	end

	if #t2 == 0 then
		return nil
	end

	local v16 = nil

	for _, v18 in t2 do
		if v16 == nil then
			v16 = v18
		end

		if v18.index < v16.index then
			v16 = v18
		end
	end

	return v16
end

return findOr
