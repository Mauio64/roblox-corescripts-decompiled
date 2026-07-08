local Constants = require(script.Parent.Constants)
local getTextHeight = require(script.Parent.getTextHeight)

require(script.Parent.StyleTypes)

return function(t1: {[any]: any}) -- line: 13
	-- upvalues: Constants (copy), getTextHeight (copy)
	local v4 = t1 and t1.nameTopPadding or Constants.NAME_TOP_PADDING
	local v5 = t1 and t1.contextualTopPadding or Constants.CONTEXTUAL_TOP_PADDING
	local v6 = t1 and t1.maxLinesNumber or Constants.LINES_MAX
	local font = t1.font
	local v8 = getTextHeight("", font.CaptionHeader.Font, font.BaseSize * font.CaptionHeader.RelativeSize)
	local v9 = getTextHeight("", font.CaptionBody.Font, font.BaseSize * font.CaptionBody.RelativeSize) * v6

	return v4 + v8 + v5 + v9
end
