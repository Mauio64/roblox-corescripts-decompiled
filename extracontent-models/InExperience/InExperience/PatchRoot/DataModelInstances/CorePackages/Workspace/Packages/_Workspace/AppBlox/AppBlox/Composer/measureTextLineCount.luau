local AppBlox = script:FindFirstAncestor("AppBlox")
local Style = require(AppBlox.Parent.Style)
local getVisibleLineCount = require(script.Parent.getVisibleLineCount)
local composerDebug = require(script.Parent.composerDebug)

local function measureTextLineCount(data)
	local visibleLineCount = getVisibleLineCount(data.text, data.maxLines)
	local unclampedLineCount = 1

	if data.text ~= "" then
		for _ in string.gmatch(data.text, "\n") do
			unclampedLineCount += 1
		end
	end

	local layoutWidth = data.layoutWidth or 0
	local boundsY = nil
	local wrappedLineCount = nil

	if data.text == "" then
		composerDebug.log("measure", `empty -> lineCount=1 layoutWidth={layoutWidth}`)
		return {
			lineCount = 1,
			unclampedLineCount = 1,
			newlineLineCount = 1,
			wrappedLineCount = nil,
			layoutWidth = layoutWidth,
			boundsY = nil
		}
	end

	local lineCount

	if layoutWidth > 0 then
		local y = Style.GetTextSize("M", data.fontSize, data.font, Vector2.new(layoutWidth, 100000), {
			addTemporaryPadding = false
		}).Y

		boundsY = Style.GetTextSize(data.text, data.fontSize, data.font, Vector2.new(layoutWidth, 100000), {
			addTemporaryPadding = false
		}).Y

		if boundsY > 0 and y > 0 then
			wrappedLineCount = math.ceil(boundsY / y)
			unclampedLineCount = math.max(unclampedLineCount, wrappedLineCount)

			lineCount = math.clamp(unclampedLineCount, 1, data.maxLines)

			boundsY = unclampedLineCount * data.singleLineHeight
		else
			lineCount = visibleLineCount
		end
	else
		lineCount = visibleLineCount
	end

	composerDebug.log(
		"measure",
		`lineCount={lineCount} newlines={visibleLineCount} wrapped={wrappedLineCount or "nil"} boundsY={boundsY or "nil"} layoutWidth={layoutWidth} textLen={utf8.len(data.text) or #data.text}`
	)
	return {
		lineCount = lineCount,
		unclampedLineCount = unclampedLineCount,
		newlineLineCount = visibleLineCount,
		wrappedLineCount = wrappedLineCount,
		layoutWidth = layoutWidth,
		boundsY = boundsY
	}
end

return measureTextLineCount
