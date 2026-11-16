local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local Localization = require(parent.Localization)
local React = require(parent.React)
require(Moments.Enums.MomentsFeedType)
local MomentsHeaderContainer = require(Moments.Components.MomentsHeader.MomentsHeaderContainer)

local useLocalization = Localization.Hooks.useLocalization

local v = { defaultTitle = "Feature.Moments.Label.MomentsExperienceName" }

local function TopBar(props)
	local v2 = useLocalization(v)

	return React.createElement(MomentsHeaderContainer, {
		layoutOrder = props.layoutOrder,
		variant = props.isBaseScreen and "base" or "close",
		showFtuxTooltip = props.showFtuxTooltip,
		onFtuxTooltipDismissed = props.onFtuxTooltipDismissed,
		onCreatePressed = props.onCreatePressed,
		onClose = props.onClose,
		onNavigateToTrending = props.onNavigateToTrending,
		onNavigateToMyMoments = props.onNavigateToMyMoments,
		title = props.title or v2.defaultTitle,
		showTopScrim = props.showTopScrim,
		animateWithImmersiveChrome = true,
		showHamburger = props.showHamburger,
		selectedFeedType = props.selectedFeedType,
		onFeedTypeSelected = props.onFeedTypeSelected
	})
end

return TopBar
