local text = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/AppCommonLib").Text
local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/SocialCommon/Components/CarouselUserTile/Constants")
require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/UIBlox")

return function(data)
	local nameTopPadding = data and data.nameTopPadding or Constants.NAME_TOP_PADDING
	local contextualTopPadding = data and data.contextualTopPadding or Constants.CONTEXTUAL_TOP_PADDING
	local maxLinesNumber = data and data.maxLinesNumber or Constants.LINES_MAX

	local font = data.font

	local textHeight = text.GetTextHeight(
		"",
		font.CaptionHeader.Font,
		font.BaseSize * font.CaptionHeader.RelativeSize,
		10000
	)
	local v5 = text.GetTextHeight(
		"",
		font.CaptionBody.Font,
		font.BaseSize * font.CaptionBody.RelativeSize,
		10000
	) * maxLinesNumber

	return nameTopPadding + textHeight + contextualTopPadding + v5
end
