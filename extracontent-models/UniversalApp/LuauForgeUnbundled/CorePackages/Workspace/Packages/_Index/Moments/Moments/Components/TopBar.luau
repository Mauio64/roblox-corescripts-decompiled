local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Localization")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")
require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Enums/MomentsFeedType")
local MomentsHeaderContainer = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/MomentsHeader/MomentsHeaderContainer")
local fFlagMomentsCreateAvatarPosts = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SharedFlags").FFlagMomentsCreateAvatarPosts

local useLocalization = Localization.Hooks.useLocalization

local v5 = { defaultTitle = "Feature.Moments.Label.MomentsExperienceName" }

local function TopBar(props)
	local v6 = useLocalization(v5)

	local createElement = React.createElement
	local v8 = {
		layoutOrder = props.layoutOrder,
		variant = props.isBaseScreen and "base" or "close",
		showFtuxTooltip = props.showFtuxTooltip,
		onFtuxTooltipDismissed = props.onFtuxTooltipDismissed,
		onCreatePressed = props.onCreatePressed,
		onCreateAvatarMomentPressed = 0,
		onClose = 0,
		onNavigateToTrending = 0,
		onNavigateToMyMoments = 0,
		title = 0,
		showTopScrim = 0,
		animateWithImmersiveChrome = true,
		showHamburger = 0,
		selectedFeedType = 0,
		onFeedTypeSelected = 0
	}

	local v9 = if fFlagMomentsCreateAvatarPosts then props.onCreateAvatarMomentPressed else nil
	v8.onCreateAvatarMomentPressed = v9

	v8.onClose = props.onClose
	v8.onNavigateToTrending = props.onNavigateToTrending
	v8.onNavigateToMyMoments = props.onNavigateToMyMoments
	v8.title = props.title or v6.defaultTitle
	v8.showTopScrim = props.showTopScrim

	v8.showHamburger = props.showHamburger
	v8.selectedFeedType = props.selectedFeedType
	v8.onFeedTypeSelected = props.onFeedTypeSelected
	return createElement(MomentsHeaderContainer, v8)
end

return TopBar
