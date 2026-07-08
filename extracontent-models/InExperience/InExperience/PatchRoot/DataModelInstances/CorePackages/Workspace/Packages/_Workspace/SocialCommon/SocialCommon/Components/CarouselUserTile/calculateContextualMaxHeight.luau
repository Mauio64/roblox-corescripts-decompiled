local Parent = script:FindFirstAncestor("SocialCommon").Parent
local Text = require(Parent.AppCommonLib).Text
local Constants = require(script.Parent.Constants)

require(Parent.UIBlox)

return function(t1: {[any]: any}) -- line: 16
	-- upvalues: Constants (copy), Text (copy)
	local v5 = t1 and t1.nameTopPadding or Constants.NAME_TOP_PADDING
	local v6 = t1 and t1.contextualTopPadding or Constants.CONTEXTUAL_TOP_PADDING
	local v7 = t1 and t1.maxLinesNumber or Constants.LINES_MAX
	local font = t1.font
	local v9 = Text.GetTextHeight("", font.CaptionHeader.Font, font.BaseSize * font.CaptionHeader.RelativeSize, 10000)
	local v10 = Text.GetTextHeight("", font.CaptionBody.Font, font.BaseSize * font.CaptionBody.RelativeSize, 10000) * v7

	return v5 + v9 + v6 + v10
end
