local Parent = script:FindFirstAncestor("UserActivationFramework").Parent

require(Parent.RobloxAppHooks)
require(Parent.Style)

return function(_, p2) -- line: 22
	return {
		horizontalPaddingPx = p2.Size.Size_500,
		verticalPaddingPx = p2.Size.Size_100,
		headerTopPadding = p2.Size.Size_800,
		headerIconSize = p2.Size.Size_900,
		footerButtonMarginBetweenPx = p2.Size.Size_200,
		footerButtonHeightPx = p2.Size.Size_1200,
		footerTopPaddingPx = p2.Size.Size_400,
		subfooterTopPaddingPx = p2.Size.Size_400,
		subfooterBottomPaddingPx = p2.Size.Size_250
	}
end
