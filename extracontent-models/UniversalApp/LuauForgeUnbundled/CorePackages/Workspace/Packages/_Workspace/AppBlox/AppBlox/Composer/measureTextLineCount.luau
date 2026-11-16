local Style = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/Style")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/Foundation")
local getVisibleLineCount = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/AppBlox/Composer/getVisibleLineCount")
local composerDebug = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/AppBlox/Composer/composerDebug")

local TextService = game:GetService("TextService")
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

local function measureTextLineCount(data)
	local v5 = getVisibleLineCount(data.text, data.maxLines)
	local v6 = 1

	if data.text ~= "" then
		for k in string.gmatch(data.text, "\n") do
			v6 += 1
		end
	end

	local layoutWidth = data.layoutWidth or 0
	local v7 = nil
	local v8 = nil

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

	local v9

	if layoutWidth > 0 then
		local y

		if foundationFontFaceMigration then
			y = Style.GetTextSize("M", data.fontSize, data.font, Vector2.new(layoutWidth, 100000), {
				addTemporaryPadding = false
			}).Y
		else
			y = TextService:GetTextSize("M", data.fontSize, data.font, Vector2.new(layoutWidth, 100000)).Y
		end

		v7 = (if foundationFontFaceMigration then Style.GetTextSize(
			data.text,
			data.fontSize,
			data.font,
			Vector2.new(layoutWidth, 100000),
			{ addTemporaryPadding = false }
		) else TextService:GetTextSize(
			data.text,
			data.fontSize,
			data.font,
			Vector2.new(layoutWidth, 100000)
		)).Y

		if v7 > 0 and y > 0 then
			v8 = math.ceil(v7 / y)
			v6 = (math.max)(v6, v8)

			v9 = math.clamp(v6, 1, data.maxLines)

			v7 = v6 * data.singleLineHeight
		else
			v9 = v5
		end
	else
		v9 = v5
	end

	composerDebug.log(
		"measure",
		`lineCount={v9} newlines={v5} wrapped={v8 or "nil"} boundsY={v7 or "nil"} layoutWidth={layoutWidth} textLen={utf8.len(data.text) or #data.text}`
	)
	return {
		lineCount = v9,
		unclampedLineCount = v6,
		newlineLineCount = v5,
		wrappedLineCount = v8,
		layoutWidth = layoutWidth,
		boundsY = v7
	}
end

return measureTextLineCount
