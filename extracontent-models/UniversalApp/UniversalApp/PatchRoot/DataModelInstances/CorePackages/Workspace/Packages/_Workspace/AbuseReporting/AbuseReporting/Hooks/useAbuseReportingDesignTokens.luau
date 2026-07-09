local AbuseReporting = script:FindFirstAncestor("AbuseReporting")
local AbuseReportingParent = AbuseReporting.Parent
local React = require(AbuseReportingParent.React)
local useDesignTokens = require(AbuseReportingParent.Style).useDesignTokens

require(AbuseReporting.Common.Types)

local function tokenSelector(p1) -- line: 8
	return p1.LuaApps.AbuseReporting or {
		ReportBackground = {},
		ReportHeader = {},
		ReportActionBar = {},
		ReportStep = {},
		ReportListSelection = {},
		ReportSubmission = {}
	}
end

return function() -- line: 20
	-- upvalues: useDesignTokens (copy), tokenSelector (copy), React (copy)
	local v7 = useDesignTokens(tokenSelector)
	local backgroundColor = v7.ReportBackground.backgroundColor
	local gradientRotation = v7.ReportBackground.gradientRotation
	local gradientTransparency = v7.ReportBackground.gradientTransparency
	local t1 = {
		backgroundColor = backgroundColor,
		gradientRotation = gradientRotation,
		gradientTransparency = gradientTransparency
	}
	local size = v7.ReportHeader.size
	local verticalPadding = v7.ReportHeader.verticalPadding
	local titleFontStyle = v7.ReportHeader.titleFontStyle
	local subtitleFontStyle = v7.ReportHeader.subtitleFontStyle
	local titleTextColor = v7.ReportHeader.titleTextColor
	local subtitleTextColor = v7.ReportHeader.subtitleTextColor
	local dividerColor = v7.ReportHeader.dividerColor
	local dividerHeight = v7.ReportHeader.dividerHeight
	local dividerVerticalPadding = v7.ReportHeader.dividerVerticalPadding
	local t2 = {
		size = size,
		verticalPadding = verticalPadding,
		titleFontStyle = titleFontStyle,
		subtitleFontStyle = subtitleFontStyle,
		titleTextColor = titleTextColor,
		subtitleTextColor = subtitleTextColor,
		dividerColor = dividerColor,
		dividerHeight = dividerHeight,
		dividerVerticalPadding = dividerVerticalPadding
	}
	local size2 = v7.ReportActionBar.size
	local buttonListHorizontalPadding = v7.ReportActionBar.buttonListHorizontalPadding
	local buttonHeight = v7.ReportActionBar.buttonHeight
	local buttonWidth = v7.ReportActionBar.buttonWidth
	local t3 = {
		size = size2,
		buttonListHorizontalPadding = buttonListHorizontalPadding,
		buttonHeight = buttonHeight,
		buttonWidth = buttonWidth
	}
	local size3 = v7.ReportStep.size
	local headerFontStyle = v7.ReportStep.headerFontStyle
	local headerTextColor = v7.ReportStep.headerTextColor
	local verticalPadding2 = v7.ReportStep.verticalPadding
	local t4 = {
		size = size3,
		headerFontStyle = headerFontStyle,
		headerTextColor = headerTextColor,
		verticalPadding = verticalPadding2
	}
	local listEntrySize = v7.ReportListSelection.listEntrySize
	local t5 = {
		listEntrySize = listEntrySize
	}
	local entryTitleColor = v7.ReportSubmission.entryTitleColor
	local entryTextColor = v7.ReportSubmission.entryTextColor
	local entryFontStyle = v7.ReportSubmission.entryFontStyle
	local entrySize = v7.ReportSubmission.entrySize
	local entryInnerVerticalPadding = v7.ReportSubmission.entryInnerVerticalPadding
	local dividerHeight2 = v7.ReportSubmission.dividerHeight
	local dividerColor2 = v7.ReportSubmission.dividerColor
	local dividerVerticalPadding2 = v7.ReportSubmission.dividerVerticalPadding
	local t6 = {
		entrySize = entrySize,
		entryTitleColor = entryTitleColor,
		entryTextColor = entryTextColor,
		entryFontStyle = entryFontStyle,
		entryInnerVerticalPadding = entryInnerVerticalPadding,
		dividerHeight = dividerHeight2,
		dividerColor = dividerColor2,
		dividerVerticalPadding = dividerVerticalPadding2
	}

	return React.useMemo(function() -- line: 112
		-- upvalues: backgroundColor (copy), gradientRotation (copy), gradientTransparency (copy), size (copy), verticalPadding (copy), titleFontStyle (copy), subtitleFontStyle (copy), titleTextColor (copy), subtitleTextColor (copy), dividerColor (copy), dividerHeight (copy), dividerVerticalPadding (copy), size2 (copy), buttonListHorizontalPadding (copy), buttonHeight (copy), buttonWidth (copy), size3 (copy), headerFontStyle (copy), headerTextColor (copy), verticalPadding2 (copy), listEntrySize (copy), entrySize (copy), entryTitleColor (copy), entryTextColor (copy), entryFontStyle (copy), entryInnerVerticalPadding (copy), dividerHeight2 (copy), dividerColor2 (copy), dividerVerticalPadding2 (copy)
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
			ReportListSelection = {
				listEntrySize = listEntrySize
			},
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
		t1,
		t2,
		t3,
		t4,
		t5,
		t6
	})
end
