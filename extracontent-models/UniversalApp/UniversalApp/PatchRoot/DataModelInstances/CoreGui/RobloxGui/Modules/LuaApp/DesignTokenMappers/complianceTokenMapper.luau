local CorePackages = game:GetService("CorePackages")

require(CorePackages.Workspace.Packages.RobloxAppHooks)
require(CorePackages.Workspace.Packages.Style)

local function makeComplianceTokenMapper(_, p2) -- line: 11
	return {
		xButtonSize = p2.Size.Size_900,
		xLeftPadding = p2.Size.Size_200,
		paddingTop = p2.Size.Size_1400,
		paddingBottom = p2.Size.Size_1200,
		paddingRight = p2.Size.Size_600,
		paddingLeft = p2.Size.Size_600,
		titleSize = p2.FontSize.FontSize_1200,
		messageSize = p2.FontSize.FontSize_400,
		messagePaddingTop = p2.Size.Size_1200,
		messagePaddingTopExtended = p2.Size.Size_1800,
		messagePaddingBottomReduced = p2.Size.Size_600,
		messagePaddingBottom = p2.Size.Size_1200,
		messagePaddingTopWideView = p2.Size.Size_600,
		messagePaddingTopWideViewExtended = p2.Size.Size_1800,
		messagePaddingBottomWideView = p2.Size.Size_300,
		dividerPaddingTop = p2.Size.Size_1200,
		listPaddingBottom = p2.Size.Size_600,
		checkboxSize = p2.Size.Size_600,
		checkboxPadding = p2.Size.Size_400,
		checkboxPaddingBottom = p2.Size.Size_500,
		agreeButtonHeight = p2.Size.Size_1200,
		agreeButtonPaddingBottom = p2.Size.Size_200
	}
end

return makeComplianceTokenMapper
