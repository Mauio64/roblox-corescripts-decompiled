local utf8Range = require(script.Parent.utf8Range)

local function byteIndexAt(text: string, p: number) -- 1 equivalent call inferred from this helper
	if utf8.len(text) == nil then
		return nil
	end

	return utf8.offset(text, p)
end

local function characterIndexAt(text: string, cursorPosition: number) -- 1 equivalent call inferred from this helper
	if cursorPosition < 1 then
		return nil
	end

	local v = utf8.len((string.sub(text, 1, cursorPosition - 1)))

	if v == nil then
		return nil
	end

	return v + 1
end

local function placeCursor(p, p2: number) -- 1 equivalent call inferred from this helper
	local cursorPosition = byteIndexAt(p.Text, p2) -- inferred equivalent call

	if cursorPosition ~= nil then
		p.CursorPosition = cursorPosition
	end
end

local TextBoxRange = {}

function TextBoxRange.readCursor(p)
	return characterIndexAt(p.Text, p.CursorPosition) -- inferred equivalent call
end

TextBoxRange.placeCursor = placeCursor

function TextBoxRange.splice(p, p2: number, p3: number, p4: string)
	local splice, v = utf8Range.splice(p.Text, p2, p3, p4)

	if splice == nil or v == nil then
		return false, nil
	end

	p.Text = splice
	placeCursor(p, v) -- inferred equivalent call
	return true, v
end

return TextBoxRange
