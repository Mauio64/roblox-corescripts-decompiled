local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local Localization = require(parent.Localization)
local React = require(parent.React)
require(Moments.Enums.MomentsFeedType)
local MomentsHeaderContainer = require(Moments.Components.MomentsHeader.MomentsHeaderContainer)
local SharedFlags = require(parent.SharedFlags)
local FFlagMomentsCreateAvatarPosts = SharedFlags.FFlagMomentsCreateAvatarPosts

local useLocalization = Localization.Hooks.useLocalization

local v = { defaultTitle = "Feature.Moments.Label.MomentsExperienceName" }

local function TopBar(props)
	local v2 = useLocalization(v)

	local createElement = React.createElement
	local v3 = {
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
	local onCreateAvatarMomentPressed

	if FFlagMomentsCreateAvatarPosts then
		onCreateAvatarMomentPressed = props.onCreateAvatarMomentPressed
	end

	v3.onCreateAvatarMomentPressed = onCreateAvatarMomentPressed

	v3.onClose = props.onClose
	v3.onNavigateToTrending = props.onNavigateToTrending
	v3.onNavigateToMyMoments = props.onNavigateToMyMoments
	v3.title = props.title or v2.defaultTitle
	v3.showTopScrim = props.showTopScrim

	v3.showHamburger = props.showHamburger
	v3.selectedFeedType = props.selectedFeedType
	v3.onFeedTypeSelected = props.onFeedTypeSelected
	return createElement(MomentsHeaderContainer, v3)
end

return TopBar
