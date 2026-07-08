local v1 = "([" .. ("$%^()-[].?"):gsub("(.)", "%%%1") .. "])"

return function(s1: string, s2: string, n1: number?) -- line: 23
	-- upvalues: v1 (copy)
	local v5 = #s1
	local v6 = n1 == nil and 1 or if not (n1 < 1) then n1 else 1

	if #s2 == 0 then
		if v5 < v6 then
			return v5
		end

		return v6
	end

	if v5 < v6 then
		return -1
	end

	local v7 = s2:gsub(v1, "%%%1")
	local v8 = #v7

	for i = v6, v5 do
		if v7 == string.sub(s1, i, i + v8 - 1) then
			return i
		end
	end

	return -1
end
