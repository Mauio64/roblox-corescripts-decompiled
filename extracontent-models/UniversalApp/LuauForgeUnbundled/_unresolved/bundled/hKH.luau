local module = require("@luauforge/bundled/hKp")
local useDesignTokens = require("@luauforge/bundled/hKI").useDesignTokens
require("@luauforge/bundled/hKz")

local function tokenSelector(p2)
	return p2.LuaApps.AbuseReporting or {
		ReportBackground = {},
		ReportHeader = {},
		ReportActionBar = {},
		ReportStep = {},
		ReportListSelection = {},
		ReportSubmission = {}
	}
end

return function()
	local v5 = useDesignTokens(tokenSelector)

	local backgroundColor = v5.ReportBackground.backgroundColor
	local gradientRotation = v5.ReportBackground.gradientRotation
	local gradientTransparency = v5.ReportBackground.gradientTransparency

	local size = v5.ReportHeader.size
	local verticalPadding = v5.ReportHeader.verticalPadding
	local titleFontStyle = v5.ReportHeader.titleFontStyle
	local subtitleFontStyle = v5.ReportHeader.subtitleFontStyle
	local titleTextColor = v5.ReportHeader.titleTextColor
	local subtitleTextColor = v5.ReportHeader.subtitleTextColor
	local dividerColor = v5.ReportHeader.dividerColor
	local dividerHeight = v5.ReportHeader.dividerHeight
	local dividerVerticalPadding = v5.ReportHeader.dividerVerticalPadding

	local size2 = v5.ReportActionBar.size
	local buttonListHorizontalPadding = v5.ReportActionBar.buttonListHorizontalPadding
	local buttonHeight = v5.ReportActionBar.buttonHeight
	local buttonWidth = v5.ReportActionBar.buttonWidth

	local size3 = v5.ReportStep.size
	local headerFontStyle = v5.ReportStep.headerFontStyle
	local headerTextColor = v5.ReportStep.headerTextColor
	local verticalPadding2 = v5.ReportStep.verticalPadding

	local listEntrySize = v5.ReportListSelection.listEntrySize

	local entryTitleColor = v5.ReportSubmission.entryTitleColor
	local entryTextColor = v5.ReportSubmission.entryTextColor
	local entryFontStyle = v5.ReportSubmission.entryFontStyle
	local entrySize = v5.ReportSubmission.entrySize
	local entryInnerVerticalPadding = v5.ReportSubmission.entryInnerVerticalPadding
	local dividerHeight2 = v5.ReportSubmission.dividerHeight
	local dividerColor2 = v5.ReportSubmission.dividerColor
	local dividerVerticalPadding2 = v5.ReportSubmission.dividerVerticalPadding
	return module.useMemo(function()
		return {
			ReportBackground = {
				backgroundColor = backgroundColor,
				gradientRotation = gradientRotation,
				gradientTransparency = gradientTransparency
			},
			ReportHeader = {
				size = size,
				verticalPadding = verticalPadding,
				titleFontStyle = titleFontStyle,
				subtitleFontStyle = subtitleFontStyle,
				titleTextColor = titleTextColor,
				subtitleTextColor = subtitleTextColor,
				dividerColor = dividerColor,
				dividerHeight = dividerHeight,
				dividerVerticalPadding = dividerVerticalPadding
			},
			ReportActionBar = {
				size = size2,
				buttonListHorizontalPadding = buttonListHorizontalPadding,
				buttonHeight = buttonHeight,
				buttonWidth = buttonWidth
			},
			ReportStep = {
				size = size3,
				headerFontStyle = headerFontStyle,
				headerTextColor = headerTextColor,
				verticalPadding = verticalPadding2
			},
			ReportListSelection = { listEntrySize = listEntrySize },
			ReportSubmission = {
				entrySize = entrySize,
				entryTitleColor = entryTitleColor,
				entryTextColor = entryTextColor,
				entryFontStyle = entryFontStyle,
				entryInnerVerticalPadding = entryInnerVerticalPadding,
				dividerHeight = dividerHeight2,
				dividerColor = dividerColor2,
				dividerVerticalPadding = dividerVerticalPadding2
			}
		}
	end, {
		{
			backgroundColor = backgroundColor,
			gradientRotation = gradientRotation,
			gradientTransparency = gradientTransparency
		},
		{
			size = size,
			verticalPadding = verticalPadding,
			titleFontStyle = titleFontStyle,
			subtitleFontStyle = subtitleFontStyle,
			titleTextColor = titleTextColor,
			subtitleTextColor = subtitleTextColor,
			dividerColor = dividerColor,
			dividerHeight = dividerHeight,
			dividerVerticalPadding = dividerVerticalPadding
		},
		{
			size = size2,
			buttonListHorizontalPadding = buttonListHorizontalPadding,
			buttonHeight = buttonHeight,
			buttonWidth = buttonWidth
		},
		{
			size = size3,
			headerFontStyle = headerFontStyle,
			headerTextColor = headerTextColor,
			verticalPadding = verticalPadding2
		},
		{ listEntrySize = listEntrySize },
		{
			entrySize = entrySize,
			entryTitleColor = entryTitleColor,
			entryTextColor = entryTextColor,
			entryFontStyle = entryFontStyle,
			entryInnerVerticalPadding = entryInnerVerticalPadding,
			dividerHeight = dividerHeight2,
			dividerColor = dividerColor2,
			dividerVerticalPadding = dividerVerticalPadding2
		}
	})
end
