local parent = script:FindFirstAncestor("SocialCommon").Parent
local AppCommonLib = require(parent.AppCommonLib)
local Text = AppCommonLib.Text
local Constants = require(script.Parent.Constants)
require(parent.UIBlox)

return function(data)
	local nameTopPadding = data and data.nameTopPadding or Constants.NAME_TOP_PADDING
	local contextualTopPadding = data and data.contextualTopPadding or Constants.CONTEXTUAL_TOP_PADDING
	local maxLinesNumber = data and data.maxLinesNumber or Constants.LINES_MAX

	local font = data.font

	local textHeight = Text.GetTextHeight(
		"",
		font.CaptionHeader.Font,
		font.BaseSize * font.CaptionHeader.RelativeSize,
		10000
	)
	local v = Text.GetTextHeight("", font.CaptionBody.Font, font.BaseSize * font.CaptionBody.RelativeSize, 10000) * maxLinesNumber

	return nameTopPadding + textHeight + contextualTopPadding + v
end
