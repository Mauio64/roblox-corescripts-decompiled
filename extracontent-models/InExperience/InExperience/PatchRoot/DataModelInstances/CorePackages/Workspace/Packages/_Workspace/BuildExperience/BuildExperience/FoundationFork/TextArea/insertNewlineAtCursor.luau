local function insertNewlineAtCursor(s1: string, n1: number) -- line: 1
	if n1 < 1 then
		local v4 = utf8.len(s1)
		local v5 = s1 .. "\n"

		if v4 then
			return v5, v4 + 1
		end

		return v5, 1
	end

	local v6 = utf8.offset(s1, n1)

	if v6 == nil then
		local v7 = utf8.len(s1)
		local v8 = s1 .. "\n"

		if v7 then
			return v8, v7 + 1
		end

		return v8, 1
	end

	return string.sub(s1, 1, v6 - 1) .. "\n" .. string.sub(s1, v6), n1 + 1
end

return insertNewlineAtCursor
