require("@game/CorePackages/Workspace/Packages/RobloxAppHooks")

require("@game/CorePackages/Workspace/Packages/Style")

local function makeComplianceTokenMapper(p2, p3)
	return {
		xButtonSize = p3.Size.Size_900,
		xLeftPadding = p3.Size.Size_200,
		paddingTop = p3.Size.Size_1400,
		paddingBottom = p3.Size.Size_1200,
		paddingRight = p3.Size.Size_600,
		paddingLeft = p3.Size.Size_600,
		titleSize = p3.FontSize.FontSize_1200,
		messageSize = p3.FontSize.FontSize_400,
		messagePaddingTop = p3.Size.Size_1200,
		messagePaddingTopExtended = p3.Size.Size_1800,
		messagePaddingBottomReduced = p3.Size.Size_600,
		messagePaddingBottom = p3.Size.Size_1200,
		messagePaddingTopWideView = p3.Size.Size_600,
		messagePaddingTopWideViewExtended = p3.Size.Size_1800,
		messagePaddingBottomWideView = p3.Size.Size_300,
		dividerPaddingTop = p3.Size.Size_1200,
		listPaddingBottom = p3.Size.Size_600,
		checkboxSize = p3.Size.Size_600,
		checkboxPadding = p3.Size.Size_400,
		checkboxPaddingBottom = p3.Size.Size_500,
		agreeButtonHeight = p3.Size.Size_1200,
		agreeButtonPaddingBottom = p3.Size.Size_200
	}
end

return makeComplianceTokenMapper
