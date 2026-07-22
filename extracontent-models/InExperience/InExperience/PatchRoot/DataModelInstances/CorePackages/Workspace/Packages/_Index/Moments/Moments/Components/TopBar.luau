local Moments = script:FindFirstAncestor("Moments")
local MomentsParent = Moments.Parent
local Localization = require(MomentsParent.Localization)
local React = require(MomentsParent.React)
local MomentsHeaderContainer = require(Moments.Components.MomentsHeader.MomentsHeaderContainer)
local useLocalization = Localization.Hooks.useLocalization
local t1 = {
	defaultTitle = "Feature.Moments.Label.MomentsExperienceName"
}

local function TopBar(t2: {[any]: any}) -- line: 30
	-- upvalues: useLocalization (copy), t1 (copy), React (copy), MomentsHeaderContainer (copy)
	local v10 = useLocalization(t1)

	return React.createElement(MomentsHeaderContainer, {
		animateWithImmersiveChrome = true,
		layoutOrder = t2.layoutOrder,
		variant = not t2.isBaseScreen and "close" or "base",
		showFtuxTooltip = t2.showFtuxTooltip,
		onFtuxTooltipDismissed = t2.onFtuxTooltipDismissed,
		onCreatePressed = t2.onCreatePressed,
		onClose = t2.onClose,
		onNavigateToTrending = t2.onNavigateToTrending,
		onNavigateToMyMoments = t2.onNavigateToMyMoments,
		title = t2.title or v10.defaultTitle,
		showTopScrim = t2.showTopScrim,
		showHamburger = t2.showHamburger
	})
end

return TopBar
