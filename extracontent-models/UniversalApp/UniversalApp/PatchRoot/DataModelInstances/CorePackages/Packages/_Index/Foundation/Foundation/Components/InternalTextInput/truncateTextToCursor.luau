local function charAt(s1: string, n1: number) -- line: 10
	return s1:sub(n1, n1)
end
local function truncateTextToCursor(p1) -- line: 27
	local CursorPosition = p1.CursorPosition

	if CursorPosition == -1 then
		return ""
	end

	local p1Text = p1.Text
	local v8 = p1.TextSize * p1.LineHeight / 1.4
	local v9 = CursorPosition + p1.AbsoluteSize.X / v8
	local v10 = string.find(p1Text, "\n", CursorPosition) or 1e999
	local v11 = string.find(p1Text, "[ \t\f\v]", CursorPosition) or 1e999
	local v12 = math.min(v10 - 1, v11, #p1Text)
	local v13 = p1Text:sub(CursorPosition, CursorPosition):match("\n")

	if v13 then
		local v14 = CursorPosition - 1

		v13 = p1Text:sub(v14, v14):match("\n") or CursorPosition == 1
	end

	if v13 then
		v12 = CursorPosition - 1
	elseif v9 < v12 then
		v12 = CursorPosition
	end

	return utf8.char(utf8.codepoint(p1Text, 1, v12))
end

return truncateTextToCursor
