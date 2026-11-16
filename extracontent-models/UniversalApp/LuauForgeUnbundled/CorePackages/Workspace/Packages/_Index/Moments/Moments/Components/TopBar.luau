local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Localization")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")
require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Enums/MomentsFeedType")
local MomentsHeaderContainer = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/MomentsHeader/MomentsHeaderContainer")

local useLocalization = Localization.Hooks.useLocalization

local v5 = { defaultTitle = "Feature.Moments.Label.MomentsExperienceName" }

local function TopBar(props)
	local v6 = useLocalization(v5)

	return React.createElement(MomentsHeaderContainer, {
		layoutOrder = props.layoutOrder,
		variant = props.isBaseScreen and "base" or "close",
		showFtuxTooltip = props.showFtuxTooltip,
		onFtuxTooltipDismissed = props.onFtuxTooltipDismissed,
		onCreatePressed = props.onCreatePressed,
		onClose = props.onClose,
		onNavigateToTrending = props.onNavigateToTrending,
		onNavigateToMyMoments = props.onNavigateToMyMoments,
		title = props.title or v6.defaultTitle,
		showTopScrim = props.showTopScrim,
		animateWithImmersiveChrome = true,
		showHamburger = props.showHamburger,
		selectedFeedType = props.selectedFeedType,
		onFeedTypeSelected = props.onFeedTypeSelected
	})
end

return TopBar
