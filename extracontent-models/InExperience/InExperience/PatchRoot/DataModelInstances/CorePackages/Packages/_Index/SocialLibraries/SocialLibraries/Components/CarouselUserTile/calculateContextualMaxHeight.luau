local Constants = require(script.Parent.Constants)
require(script.Parent.StyleTypes)

return function(data)
	local nameTopPadding = data and data.nameTopPadding or Constants.NAME_TOP_PADDING
	local contextualTopPadding = data and data.contextualTopPadding or Constants.CONTEXTUAL_TOP_PADDING
	local maxLinesNumber = data and data.maxLinesNumber or Constants.LINES_MAX

	local font = data.font
	local v = font.BaseSize * font.CaptionHeader.RelativeSize
	local v2 = font.BaseSize * font.CaptionBody.RelativeSize * maxLinesNumber

	return nameTopPadding + v + contextualTopPadding + v2
end
