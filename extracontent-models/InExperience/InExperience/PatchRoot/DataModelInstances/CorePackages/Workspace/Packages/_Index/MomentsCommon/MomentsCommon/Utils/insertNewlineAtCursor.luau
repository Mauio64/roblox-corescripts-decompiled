local function insertNewlineAtCursor(value: string, p: number)
	local v = utf8.len(value) or #value

	if not (p >= 1 and p <= v + 1) then
		p = v + 1
	end

	local v2 = not (p > 1) and 1 or utf8.offset(value, p) or #value + 1

	return string.sub(value, 1, v2 - 1) .. "\n" .. string.sub(value, v2), p + 1
end

return insertNewlineAtCursor
