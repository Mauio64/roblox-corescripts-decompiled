local function insertNewlineAtCursor(value, p2)
	local v5 = utf8.len(value) or #value

	if not (p2 >= 1 and p2 <= v5 + 1) then
		p2 = v5 + 1
	end

	local v6 = not (p2 > 1) and 1 or utf8.offset(value, p2) or #value + 1

	return string.sub(value, 1, v6 - 1) .. "\n" .. string.sub(value, v6), p2 + 1
end

return insertNewlineAtCursor
