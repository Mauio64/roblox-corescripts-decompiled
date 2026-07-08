local TextService = game:GetService("TextService")
local getVisibleLineCount = require(script.Parent.getVisibleLineCount)
local chatTextAreaDebug = require(script.Parent.chatTextAreaDebug)

local function measureTextLineCount(t1: {[any]: any}) -- line: 25
	-- upvalues: getVisibleLineCount (copy), chatTextAreaDebug (copy), TextService (copy)
	local v6 = getVisibleLineCount(t1.text, t1.maxLines)
	local n1 = 1

	if t1.text ~= "" then
		for _ in string.gmatch(t1.text, "\n") do
			n1 += 1
		end
	end

	local v9 = t1.layoutWidth or 0
	local Y = nil
	local v11 = nil
	local v12 = v6

	if t1.text == "" then
		local t2 = {
			lineCount = 1,
			newlineLineCount = 1,
			wrappedLineCount = nil,
			boundsY = nil,
			layoutWidth = v9
		}

		chatTextAreaDebug.log("measure", `empty -> lineCount=1 layoutWidth={ v9 }`)

		return t2
	end

	if v9 > 0 then
		local Y2 = TextService:GetTextSize("M", t1.fontSize, t1.font, Vector2.new(v9, 100000)).Y

		Y = TextService:GetTextSize(t1.text, t1.fontSize, t1.font, Vector2.new(v9, 100000)).Y

		if Y > 0 and Y2 > 0 then
			v11 = math.ceil(Y / Y2)

			local v15 = math.max(n1, v11)

			v12 = math.clamp(v15, 1, t1.maxLines)
			Y = v15 * t1.singleLineHeight
		end
	end

	local t3 = {
		lineCount = v12,
		newlineLineCount = v6,
		wrappedLineCount = v11,
		layoutWidth = v9,
		boundsY = Y
	}

	chatTextAreaDebug.log("measure", `lineCount={ v12 } newlines={ v6 } wrapped={ v11 or "nil" } boundsY={ Y or "nil" } layoutWidth={ v9 } textLen={ utf8.len(t1.text) or #t1.text }`)

	return t3
end

return measureTextLineCount
