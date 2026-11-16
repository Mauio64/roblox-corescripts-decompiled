local function charAt(text: string, p: number) -- 2 equivalent calls inferred from this helper
	return text:sub(p, p)
end

local function truncateTextToCursor(data)
	local cursorPosition = data.CursorPosition

	if cursorPosition == -1 then
		return ""
	end

	local text = data.Text
	local v = data.TextSize * data.LineHeight / 1.4
	local v2 = cursorPosition + data.AbsoluteSize.X / v
	local v3 = string.find(text, "\n", cursorPosition) or 1e999
	local v4 = string.find(text, "[ \t\f\11]", cursorPosition) or 1e999
	local v5 = math.min(v3 - 1, v4, #text)

	if
		charAt(text, cursorPosition):match("\n") -- inferred equivalent call
		and (charAt(text, cursorPosition - 1):match("\n") or cursorPosition == 1) -- inferred equivalent call
	then
		v5 = cursorPosition - 1
	elseif v2 < v5 then
		v5 = cursorPosition
	end

	return utf8.char(utf8.codepoint(text, 1, v5))
end

return truncateTextToCursor
