local function insertNewlineAtCursor(value: string, p: number)
	if p < 1 then
		local v = utf8.len(value)
		local v2 = value .. "\n"

		if v then
			return v2, v + 1
		end

		return v2, 1
	else
		local v = utf8.offset(value, p)

		if v ~= nil then
			return string.sub(value, 1, v - 1) .. "\n" .. string.sub(value, v), p + 1
		end

		local v2 = utf8.len(value)
		local v3 = value .. "\n"

		if v2 then
			return v3, v2 + 1
		end

		return v3, 1
	end
end

return insertNewlineAtCursor
